--1.feladat
-- Hot_dog tábla létrehozása
CREATE TABLE Hot_dog (
    Azon INT PRIMARY KEY CHECK (Azon < 1000),
    Ar DECIMAL(5, 2) NOT NULL CHECK (Ar >= 1000)
);

-- Hot_dog_feltetek tábla létrehozása a kapcsolatok tárolásához
CREATE TABLE Hot_dog_feltetek (
    Hot_dog_Azon INT,
    Feltetek_Id INT,
    PRIMARY KEY (Hot_dog_Azon, Feltetek_Id),
    FOREIGN KEY (Hot_dog_Azon) REFERENCES Hot_dog(Azon)
);

CREATE TABLE Megrendelo (
    Azon INT PRIMARY KEY,
    Nev VARCHAR(50),
    Telefonszam VARCHAR(20)
);

CREATE TABLE Megrendeles (
    MegrendeloAzon INT,
    Hot_dogAzon INT,
    MegrendeloDatum DATE,
    KiszallitasDatum DATE,
    FOREIGN KEY (MegrendeloAzon) REFERENCES Megrendelo(Azon),
    FOREIGN KEY (Hot_dogAzon) REFERENCES Hot_dog(Azon),
    CHECK (KiszallitasDatum > MegrendeloDatum),
    PRIMARY KEY (MegrendeloAzon, Hot_dogAzon)
);

--2.feladat
-- Azon mező hozzáadása a Megrendeles táblához
ALTER TABLE Megrendeles
ADD COLUMN Azon INT;

-- Elsődleges kulcs beállítása az Azon, MegrendeloAzon és Hot_dogAzon oszlopokból
ALTER TABLE Megrendeles
ADD CONSTRAINT PK_Megrendeles PRIMARY KEY (Azon, MegrendeloAzon, Hot_dogAzon);

--3.feladat
--A) Vegyünk fel pár 3-5 megrendelőt és 3-5 Hot-dog-ot:
INSERT INTO Megrendelo (Azon, Nev, Telefonszam)
VALUES (1, 'John Doe', '123456789'),
(2, 'Jane Smith', '987654321'),
(3, 'Alice Johnson', '555555555'),
(4, 'Bob Williams', '777777777'),
(5, 'Emily Davis', '444444444');

INSERT INTO Hot_dog (Azon, Ar)
VALUES (1, 1500.00),
(2, 1800.00),
(3, 2000.00),
(4, 1700.00),
(5, 1900.00);

--B) Rögzítsünk pár megrendelést:
INSERT INTO Megrendeles (MegrendeloAzon, Hot_dogAzon, MegrendeloDatum, KiszallitasDatum)
VALUES (1, 1, '2023-05-15', NULL),
(2, 3, '2023-05-15', NULL),
(3, 2, '2023-05-15', NULL);

--C) Mentési pont készítése:
SAVEPOINT my_savepoint1;


--4.feladat
-- Az első megrendelés teljesítése (kiszállítási idő megadása)
UPDATE Megrendeles
SET KiszallitasDatum = '2023-05-16'
WHERE MegrendeloAzon = 1 AND Hot_dogAzon = 1;

-- A második megrendelés teljesítése (kiszállítási idő megadása)
UPDATE Megrendeles
SET KiszallitasDatum = '2023-05-17'
WHERE MegrendeloAzon = 2 AND Hot_dogAzon = 3;

-- A harmadik megrendelés teljesítése (kiszállítási idő megadása)
UPDATE Megrendeles
SET KiszallitasDatum = '2023-05-18'
WHERE MegrendeloAzon = 3 AND Hot_dogAzon = 2;

-- A negyedik megrendelés teljesítése (kiszállítási idő megadása)
UPDATE Megrendeles
SET KiszallitasDatum = '2023-05-19'
WHERE MegrendeloAzon = 4 AND Hot_dogAzon = 4;

-- Az ötödik megrendelés még nem teljesült (nincs kiszállítási idő megadva)

--5.feladat
--A) A nem teljesített megrendeléshez tartozó adatok lekérdezése:
SELECT *
FROM Megrendeles
WHERE KiszallitasDatum IS NULL;

--B) A megrendelés törlése:
DELETE FROM Megrendeles
WHERE MegrendeloAzon = [megrendelő azonosító] AND Hot_dogAzon = [hot-dog azonosító];


--6.feladat
--A) Mentési pont készítése:
SAVEPOINT my_savepoint2;

--B) Hot-dog-ok árának 25%-kal történő növelése a ketchup tartalom alapján:
UPDATE Hot_dog
SET Ar = Ar * 1.25
WHERE Azon IN (
SELECT Hot_dog_Azon
FROM Hot_dog_feltetek
WHERE Feltetek_Id = [ketchup feltét azonosító]
);

--C) Előző mentési pontra való visszatekintés:
ROLLBACK TO my_savepoint2;


--7.feladat
--A) Az első nap bevétele (csak a kiszállított hot-dog-ok):
SELECT SUM(Ar) AS NapiBevetel
FROM Megrendeles
JOIN Hot_dog ON Megrendeles.Hot_dogAzon = Hot_dog.Azon
WHERE KiszallitasDatum IS NOT NULL;

--B) Azon megrendelők lekérdezése, akik legalább két különböző hot-dog-ot rendeltek:
SELECT Megrendelo.Azon, Megrendelo.Nev
FROM Megrendelo
JOIN Megrendeles ON Megrendelo.Azon = Megrendeles.MegrendeloAzon
JOIN Hot_dog ON Megrendeles.Hot_dogAzon = Hot_dog.Azon
GROUP BY Megrendelo.Azon, Megrendelo.Nev
HAVING COUNT(DISTINCT Hot_dog.Azon) >= 2;

--C) Azon megrendelő lekérdezése, aki a legnagyobb értékben rendelt:
SELECT Megrendelo.Azon, Megrendelo.Nev
FROM Megrendelo
JOIN Megrendeles ON Megrendelo.Azon = Megrendeles.MegrendeloAzon
JOIN Hot_dog ON Megrendeles.Hot_dogAzon = Hot_dog.Azon
GROUP BY Megrendelo.Azon, Megrendelo.Nev
ORDER BY SUM(Hot_dog.Ar) DESC
LIMIT 1;

--D) Összetett lekérdezés (JOIN):
SELECT Megrendeles.MegrendeloAzon, Megrendelo.Nev, Hot_dog.Azon, Hot_dog.Ar
FROM Megrendeles
JOIN Megrendelo ON Megrendeles.MegrendeloAzon = Megrendelo.Azon
JOIN Hot_dog ON Megrendeles.Hot_dogAzon = Hot_dog.Azon;
