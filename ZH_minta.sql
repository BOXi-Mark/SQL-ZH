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
