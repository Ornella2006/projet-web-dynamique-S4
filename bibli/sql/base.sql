create database livre;
use livre;

CREATE TABLE Livre (
    id_livre INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(255) NOT NULL,
    auteur VARCHAR(255),
    editeur VARCHAR(255),
    annee_publication YEAR,
    genre VARCHAR(100),
    isbn VARCHAR(20) UNIQUE
);

CREATE TABLE Exemplaire (
    id_exemplaire INT PRIMARY KEY AUTO_INCREMENT,
    id_livre INT NOT NULL,
    etat VARCHAR(50) DEFAULT 'bon',
    disponible BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_livre) REFERENCES Livre(id_livre)
);

CREATE TABLE Adherent (
    id_adherent INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    type ENUM('Etudiant', 'Professionel', 'Professeur'),
    email VARCHAR(100),
    telephone VARCHAR(20),
    date_inscription DATE
);

CREATE TABLE Inscription (
    id_inscription INT PRIMARY KEY AUTO_INCREMENT,
    id_adherent INT,
    date_inscription DATE,
    date_expiration DATE,
    statut ENUM('active', 'expiree'),
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent)
);

CREATE TABLE Pret (
    id_pret INT PRIMARY KEY AUTO_INCREMENT,
    id_exemplaire INT,
    id_adherent INT,
    type_pret ENUM('Lecture sur place', 'Maison'),
    date_pret DATE,
    date_retour_prevue DATE,
    date_retour_effective DATE,
    prolongation BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire),
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent)
);

CREATE TABLE Prolongement (
    id_prolongement INT PRIMARY KEY AUTO_INCREMENT,
    id_pret INT,
    date_prolongement DATE,
    nouvelle_date_retour DATE,
    FOREIGN KEY (id_pret) REFERENCES Pret(id_pret)
);

CREATE TABLE Reservation (
    id_reservation INT PRIMARY KEY AUTO_INCREMENT,
    id_exemplaire INT,
    id_adherent INT,
    type_pret ENUM('Lecture sur place', 'Maison'),
    date_reservation DATE,
    etat ENUM('en attente', 'validee', 'annulee'),
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire),
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent)
);

CREATE TABLE Penalite (
    id_penalite INT PRIMARY KEY AUTO_INCREMENT,
    id_adherent INT,
    montant DECIMAL(10,2),
    raison VARCHAR(255),
    date_penalite DATE,
    payee BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent)
);

CREATE TABLE Cotisation (
    id_cotisation INT PRIMARY KEY AUTO_INCREMENT,
    id_adherent INT,
    montant DECIMAL(10,2),
    date_paiement DATE,
    periode VARCHAR(20),
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent)
);

CREATE TABLE JourFerie (
    id_jourferie INT PRIMARY KEY AUTO_INCREMENT,
    date_ferie DATE UNIQUE,
    description VARCHAR(255)
);

INSERT INTO JourFerie (date_ferie, description) VALUES 
('2025-01-01', 'Jour de l\'An'),
('2025-03-08', 'Journée internationale des femmes'),
('2025-03-29', 'Commémoration des martyrs'),
('2025-05-01', 'Fête du Travail'),
('2025-06-26', 'Fête de l\'Indépendance'),
('2025-08-15', 'Assomption'),
('2025-11-01', 'Toussaint'),
('2025-12-25', 'Noël'),
('2025-04-18', 'Vendredi Saint'),
('2025-04-20', 'Pâques'),
('2025-05-29', 'Ascension'),
('2025-06-08', 'Pentecôte');


