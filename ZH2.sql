-- Szobák tábla létrehozása
CREATE TABLE Szobak (
  szoba_id SERIAL PRIMARY KEY,
  emelet TEXT,
  szobaszam TEXT,
  szemelyek_szama INTEGER
);

-- Vendégek tábla létrehozása
CREATE TABLE Vendegek (
  vendeg_id SERIAL PRIMARY KEY,
  nev TEXT,
  cim TEXT,
  szuletesi_ev INTEGER,
  igazolvany_szam TEXT
);

-- Foglalások tábla létrehozása
CREATE TABLE Foglalasok (
  foglalas_id SERIAL PRIMARY KEY,
  vendeg_id INTEGER REFERENCES Vendegek(vendeg_id),
  szoba_id INTEGER REFERENCES Szobak(szoba_id),
  foglalas_datum DATE
);

INSERT INTO Szobak (emelet, szobaszam, szemelyek_szama)
VALUES
  ('1. emelet', '101', 2),
  ('2. emelet', '205', 3),
  ('3. emelet', '303', 1);

INSERT INTO Vendegek (nev, cim, szuletesi_ev, igazolvany_szam)
VALUES
  ('Kovács Anna', 'Budapest, Kossuth utca 5.', 1985, 'AB123456'),
  ('Nagy Péter', 'Debrecen, Fő utca 10.', 1978, 'CD987654'),
  ('Szabó János', 'Szeged, Kossuth tér 3.', 1992, 'EF246813');

INSERT INTO Foglalasok (vendeg_id, szoba_id, foglalas_datum)
VALUES
  (1, 1, '2023-05-15'),
  (1, 2, '2023-06-20'),
  (2, 3, '2023-07-10'),
  (3, 2, '2023-08-05');

ALTER TABLE Szobak
ADD COLUMN allapot TEXT;
ALTER TABLE Vendegek
ADD COLUMN telefonszam TEXT;
ALTER TABLE Foglalasok
ADD COLUMN fizetve BOOLEAN DEFAULT FALSE;

UPDATE Szobak
SET allapot = 'szabad'
WHERE szoba_id = 1;

UPDATE Szobak
SET allapot = 'foglalt'
WHERE szoba_id = 2;

UPDATE Szobak
SET allapot = 'karbantartas alatt'
WHERE szoba_id = 3;

UPDATE Vendegek
SET telefonszam = '123456789'
WHERE vendeg_id = 1;

UPDATE Vendegek
SET telefonszam = '987654321'
WHERE vendeg_id = 2;

UPDATE Vendegek
SET telefonszam = '555555555'
WHERE vendeg_id = 3;

UPDATE Foglalasok
SET fizetve = TRUE
WHERE foglalas_id = 1;

UPDATE Foglalasok
SET fizetve = FALSE
WHERE foglalas_id = 2;

UPDATE Foglalasok
SET fizetve = TRUE
WHERE foglalas_id = 3;

UPDATE Foglalasok
SET fizetve = FALSE
WHERE foglalas_id = 4;


DELETE FROM Foglalasok;
DELETE FROM Vendegek;
DELETE FROM Szobak;


CREATE SEQUENCE szobak_seq START 1;
CREATE SEQUENCE vendegek_seq START 1;
CREATE SEQUENCE foglalasok_seq START 1;

INSERT INTO Szobak (szoba_id, emelet, szobaszam, szemelyek_szama)
VALUES
  (nextval('szobak_seq'), '1. emelet', '101', 2),
  (nextval('szobak_seq'), '2. emelet', '205', 3),
  (nextval('szobak_seq'), '3. emelet', '303', 1);
INSERT INTO Vendegek (vendeg_id, nev, cim, szuletesi_ev, igazolvany_szam)
VALUES
  (nextval('vendegek_seq'), 'Kovács Anna', 'Budapest, Kossuth utca 5.', 1985, 'AB123456'),
  (nextval('vendegek_seq'), 'Nagy Péter', 'Debrecen, Fő utca 10.', 1978, 'CD987654'),
  (nextval('vendegek_seq'), 'Szabó János', 'Szeged, Kossuth tér 3.', 1992, 'EF246813');
INSERT INTO Foglalasok (foglalas_id, vendeg_id, szoba_id, foglalas_datum)
VALUES
  (nextval('foglalasok_seq'), currval('vendegek_seq'), currval('szobak_seq'), '2023-05-15'),
  (nextval('foglalasok_seq'), currval('vendegek_seq'), currval('szobak_seq'), '2023-06-20'),
  (nextval('foglalasok_seq'), currval('vendegek_seq'), currval('szobak_seq'), '2023-07-10'),
  (nextval('foglalasok_seq'), currval('vendegek_seq'), currval('szobak_seq'), '2023-08-05');

CREATE VIEW NemLefoglaltSzobak AS
SELECT *
FROM Szobak
WHERE szoba_id NOT IN (SELECT szoba_id FROM Foglalasok);

GRANT SELECT ON NemLefoglaltSzobak TO PUBLIC;


SELECT person.azon, COUNT(person.azon) AS ermek
FROM olimpia.o_versenyzok person
INNER JOIN olimpia.o_eredmenyek  ered ON person.azon = ered.versenyzo_azon
WHERE (ered.helyezes < 7)
GROUP BY person.azon
HAVING COUNT(ered.helyezes) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(helyezes) AS cnt
        FROM olimpia.o_eredmenyek
        WHERE (helyezes < 7)
        GROUP BY versenyzo_azon
    )
);


