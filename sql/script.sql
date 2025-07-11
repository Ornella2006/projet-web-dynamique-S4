drop database if exists gestion_bibliotheque;
CREATE DATABASE if not exists gestion_bibliotheque;
USE gestion_bibliotheque;

CREATE TABLE Profil (
    id_profil INT PRIMARY KEY AUTO_INCREMENT,
    type_profil ENUM('ETUDIANT', 'PROFESSEUR', 'PROFESSIONNEL') NOT NULL,
    duree_pret INT NOT NULL,  
    quota_pret INT NOT NULL,       
    quota_prolongement INT NOT NULL,        
    quota_reservation INT NOT NULL,          
    duree_penalite INT NOT NULL              
);



CREATE TABLE Adherent (
    id_adherent INT PRIMARY KEY AUTO_INCREMENT,
    id_profil INT NOT NULL,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telephone VARCHAR(20),
    statut ENUM('ACTIF', 'INACTIF', 'SANCTIONNE') DEFAULT 'ACTIF',
    date_naissance DATE NOT NULL, 
    quotat_restant int default null, -- Pour vérifier les restrictions d'âge
    FOREIGN KEY (id_profil) REFERENCES Profil(id_profil) ON DELETE RESTRICT
);

CREATE TABLE Abonnement (
    id_abonnement INT PRIMARY KEY AUTO_INCREMENT,
    id_adherent INT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    montant DECIMAL(10,2) NOT NULL,  -- Ajout du montant
    statut ENUM('ACTIVE', 'EXPIREE') DEFAULT 'ACTIVE',
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE
);

CREATE TABLE Livre (
    id_livre INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(255) NOT NULL,
    auteur VARCHAR(255),
    editeur VARCHAR(255),
    annee_publication YEAR,
    genre VARCHAR(100),
    isbn VARCHAR(20) UNIQUE,
    restriction_age INT DEFAULT 0,-- NULL si accessible à tous
    professeur_seulement BOOLEAN DEFAULT FALSE
);

CREATE TABLE Exemplaire (
    id_exemplaire INT PRIMARY KEY AUTO_INCREMENT,
    id_livre INT NOT NULL,
    etat ENUM('BON', 'ABIME', 'PERDU') DEFAULT 'BON',
    statut ENUM('DISPONIBLE', 'EN_PRET', 'RESERVE', 'LECTURE_SUR_PLACE') DEFAULT 'DISPONIBLE',
    FOREIGN KEY (id_livre) REFERENCES Livre(id_livre) ON DELETE CASCADE
);

CREATE TABLE Pret (
    id_pret INT PRIMARY KEY AUTO_INCREMENT,
    id_exemplaire INT NOT NULL,
    id_adherent INT NOT NULL,
    type_pret ENUM('DOMICILE', 'SUR PLACE') NOT NULL,
    date_pret DATETIME NOT NULL,
    date_retour_prevue DATETIME NOT NULL,
    date_retour_effective DATETIME,
    prolongation_count INT DEFAULT 0,
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire) ON DELETE CASCADE,
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE
);4+tgttpà^: mù     ,


CREATE TABLE Reservation (
    id_reservation INT PRIMARY KEY AUTO_INCREMENT,
    id_exemplaire INT NOT NULL,
    id_adherent INT NOT NULL,
    date_reservation DATETIME NOT NULL,
    date_retrait_prevue DATE NOT NULL,
    date_expiration DATETIME NOT NULL,
    statut ENUM('EN_ATTENTE', 'VALIDEE', 'ANNULEE', 'EXPIREE') DEFAULT 'EN_ATTENTE',
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire),
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent)
);


CREATE TABLE Prolongement (
    id_prolongement INT PRIMARY KEY AUTO_INCREMENT,
    id_pret INT NOT NULL,
    date_demande_prolongement DATETIME NOT NULL,
    nouvelle_date_retour DATETIME NOT NULL,
    statut ENUM('EN ATTENTE', 'VALIDE', 'REFUSE') DEFAULT 'EN ATTENTE',
    FOREIGN KEY (id_pret) REFERENCES Pret(id_pret)
);

CREATE TABLE Penalite (
    id_penalite INT PRIMARY KEY AUTO_INCREMENT,
    id_adherent INT NOT NULL,
    id_pret INT, 
    date_debut_penalite DATE NOT NULL,
    date_fin_penalite DATE NOT NULL,
    raison VARCHAR(255),
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE,
    FOREIGN KEY (id_pret) REFERENCES Pret(id_pret) ON DELETE SET NULL
);

CREATE TABLE jour_ferie (
    id_jourferie INT PRIMARY KEY AUTO_INCREMENT,
    date_ferie DATE UNIQUE NOT NULL,
    description VARCHAR(255),
    regle_rendu ENUM('avant', 'apres') DEFAULT 'avant'
);


INSERT INTO jour_ferie (date_ferie, description, regle_rendu) VALUES 
('2025-01-01', 'Jour de l\'An', 'avant'),
('2025-03-08', 'Journée internationale des femmes', 'avant'),
('2025-03-29', 'Commémoration des martyrs', 'avant'),
('2025-05-01', 'Fête du Travail', 'avant'),
('2025-06-26', 'Fête de l\'Indépendance', 'avant'),
('2025-08-15', 'Assomption', 'avant'),
('2025-11-01', 'Toussaint', 'avant'),
('2025-12-25', 'Noël', 'avant'),
('2025-04-18', 'Vendredi Saint', 'avant'),
('2025-04-20', 'Pâques', 'avant'),
('2025-05-29', 'Ascension', 'avant'),
('2025-06-08', 'Pentecôte', 'avant');

INSERT INTO Livre (titre, auteur, editeur, annee_publication, genre, isbn, restriction_age, professeur_seulement)
VALUES ('Livre Test', 'Auteur Test', 'Editeur Test', 2020, 'Fiction', '1234567890123', 0, FALSE);

INSERT INTO Exemplaire (id_livre, etat, statut)
VALUES (1, 'BON', 'DISPONIBLE');

INSERT INTO Adherent (id_profil, nom, prenom, email, telephone, statut, date_naissance, quotat_restant)
VALUES (1, 'Dupont', 'Jean', 'jean.dupont@example.com', '1234567890', 'ACTIF', '2000-01-01', 3);

INSERT INTO Abonnement (id_adherent, date_debut, date_fin, montant, statut)
VALUES (1, '2025-06-01', '2026-06-01', 50.00, 'ACTIVE');

-- Insert reference data for profiles
INSERT INTO Profil (type_profil, duree_pret, quota_pret, quota_prolongement, quota_reservation, duree_penalite) VALUES
('Etudiant', 7, 3, 1, 2, 10),
('Professionnel', 14, 5, 2, 3, 15),
('Professeur', 30, 3, 3, 5, 7);

CREATE TABLE User (
    id_user INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('ADHERENT', 'BIBLIOTHECAIRE') NOT NULL,
    id_adherent INT, -- NULL pour les bibliothécaires
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE
);

INSERT INTO User (email, mot_de_passe, role, id_adherent)
VALUES ('jean.dupont@example.com', 'ad1', 'ADHERENT', 1);
INSERT INTO User (email, mot_de_passe, role, id_adherent)
VALUES ('bibliothecaire@example.com', 'bibli1', 'BIBLIOTHECAIRE', NULL);

ALTER TABLE Adherent ADD quota_restant INT DEFAULT NULL;
UPDATE Adherent a
SET a.quota_restant = (SELECT p.quota_pret FROM Profil p WHERE p.id_profil = a.id_profil);