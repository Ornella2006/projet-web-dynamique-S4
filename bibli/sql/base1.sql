-- Création de la base de données
drop database if EXISTS bibliotheque;
CREATE DATABASE IF NOT EXISTS bibliotheque;
USE bibliotheque;

-- Table Livre
CREATE TABLE livre (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    auteur VARCHAR(100),
    isbn VARCHAR(13) UNIQUE NOT NULL
);

-- Table Exemplaire
CREATE TABLE exemplaire (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    reference VARCHAR(50) UNIQUE NOT NULL,
    disponible BOOLEAN NOT NULL DEFAULT TRUE,
    livre_id BIGINT,
    FOREIGN KEY (livre_id) REFERENCES livre(id)
);

-- Table Adherent
CREATE TABLE adherent (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    type ENUM('ETUDIANT', 'PROFESSIONNEL', 'PROFESSEUR') NOT NULL,
    actif BOOLEAN NOT NULL DEFAULT TRUE,
    quota_pret INT NOT NULL DEFAULT 3, -- Exemple : 3 prêts max
    date_expiration_abonnement DATE
);

-- Table Pret
CREATE TABLE pret (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    adherent_id BIGINT,
    exemplaire_id BIGINT,
    date_pret DATE NOT NULL,
    date_retour_prevu DATE NOT NULL,
    type_pret ENUM('SUR_PLACE', 'MAISON') NOT NULL,
    FOREIGN KEY (adherent_id) REFERENCES adherent(id),
    FOREIGN KEY (exemplaire_id) REFERENCES exemplaire(id)
);

-- Table Penalite
CREATE TABLE penalite (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    adherent_id BIGINT,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    raison VARCHAR(255),
    FOREIGN KEY (adherent_id) REFERENCES adherent(id)
);

-- Données de test (facultatif)
INSERT INTO livre (titre, auteur, isbn) VALUES
('Les Misérables', 'Victor Hugo', '9781234567890'),
('1984', 'George Orwell', '9780987654321');

INSERT INTO exemplaire (reference, disponible, livre_id) VALUES
('EX001', TRUE, 1),
('EX002', TRUE, 1),
('EX003', TRUE, 2);

INSERT INTO adherent (nom, type, actif, quota_pret, date_expiration_abonnement) VALUES
('Jean Dupont', 'ETUDIANT', TRUE, 3, '2026-12-31'),
('Marie Curie', 'PROFESSEUR', TRUE, 5, '2026-12-31');