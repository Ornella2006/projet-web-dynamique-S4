-- Supprimer les tables dans l'ordre inverse des dépendances
DROP TABLE IF EXISTS Prolongement;
DROP TABLE IF EXISTS Penalite;
DROP TABLE IF EXISTS Pret;
DROP TABLE IF EXISTS Reservation;
DROP TABLE IF EXISTS Exemplaire;
DROP TABLE IF EXISTS Livre;
DROP TABLE IF EXISTS Abonnement;
DROP TABLE IF EXISTS Adherent;
DROP TABLE IF EXISTS Profil;
DROP TABLE IF EXISTS jour_ferie;
DROP TABLE IF EXISTS User;

-- Recréer les tables
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
    date_fin_sanction DATE,
    quotat_restant INT,
    FOREIGN KEY (id_profil) REFERENCES Profil(id_profil) ON DELETE RESTRICT
);

DELIMITER //
CREATE TRIGGER set_default_quotat_restant
BEFORE INSERT ON Adherent
FOR EACH ROW
BEGIN
    SET NEW.quotat_restant = (SELECT quota_pret FROM Profil WHERE id_profil = NEW.id_profil);
END//
DELIMITER ;

CREATE TABLE User (
    id_user INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('ADHERENT', 'BIBLIOTHECAIRE') NOT NULL,
    id_adherent INT,
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE
);

CREATE TABLE Abonnement (
    id_abonnement INT PRIMARY KEY AUTO_INCREMENT,
    id_adherent INT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    montant DECIMAL(10,2) NOT NULL,
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
    restriction_age INT DEFAULT 0,
    professeur_seulement BOOLEAN DEFAULT FALSE
);

CREATE TABLE Exemplaire (
    id_exemplaire INT PRIMARY KEY AUTO_INCREMENT,
    id_livre INT NOT NULL,
    etat ENUM('BON', 'ABIME', 'PERDU') DEFAULT 'BON',
    statut ENUM('DISPONIBLE', 'EN_PRET', 'RESERVE', 'LECTURE_SUR_PLACE') DEFAULT 'DISPONIBLE',
    FOREIGN KEY (id_livre) REFERENCES Livre(id_livre) ON DELETE CASCADE
);

CREATE TABLE jour_ferie (
    id_jourferie INT PRIMARY KEY AUTO_INCREMENT,
    date_ferie DATE UNIQUE NOT NULL,
    description VARCHAR(255),
    regle_rendu ENUM('AVANT', 'APRES') DEFAULT 'AVANT'
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

CREATE TABLE Pret (
    id_pret INT PRIMARY KEY AUTO_INCREMENT,
    id_exemplaire INT NOT NULL,
    id_adherent INT NOT NULL,
    type_pret ENUM('DOMICILE', 'SUR PLACE') NOT NULL,
    date_pret DATE,
    date_retour_prevue DATE,
    date_retour_effective DATE,
    statut ENUM('EN_COURS', 'RETOURNE') NOT NULL DEFAULT 'EN_COURS',
    prolongation_count INT DEFAULT 0,
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire) ON DELETE CASCADE,
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE
);

CREATE TABLE Reservation (
    id_reservation INT PRIMARY KEY AUTO_INCREMENT,
    id_exemplaire INT NOT NULL,
    id_adherent INT NOT NULL,
    date_reservation DATE NOT NULL,
    date_retrait_prevue DATE NOT NULL,
    date_expiration DATE NOT NULL,
    type_pret ENUM('DOMICILE', 'SUR_PLACE') NOT NULL DEFAULT 'DOMICILE',
    statut ENUM('EN_ATTENTE', 'VALIDEE', 'ANNULEE', 'EXPIREE', 'CONVERTIE_EN_PRET') DEFAULT 'EN_ATTENTE',
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire),
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent)
);

CREATE TABLE Prolongement (
    id_prolongement INT PRIMARY KEY AUTO_INCREMENT,
    id_pret INT NOT NULL,
    date_demande_prolongement DATE NOT NULL,
    nouvelle_date_retour DATE NOT NULL,
    statut ENUM('EN ATTENTE', 'VALIDE', 'REFUSE') DEFAULT 'EN ATTENTE',
    FOREIGN KEY (id_pret) REFERENCES Pret(id_pret)
);

select * from pret;