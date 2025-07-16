-- Insérer les données dans la table Profil
INSERT INTO Profil (type_profil, duree_pret, quota_pret, quota_prolongement, quota_reservation, duree_penalite) VALUES
('ETUDIANT', 7, 2, 3, 1, 10),
('ENSEIGNANT', 9, 3, 5, 2, 9),
('PROFESSIONNEL', 12, 4, 7, 3, 8);

-- Insérer les données dans la table Adherent
INSERT INTO Adherent (id_profil, nom, prenom, email, telephone, statut, date_naissance) VALUES
(1, 'Bensaïd', 'Amine', 'amine.bensaid@example.com', '1000000001', 'ACTIF', '2000-01-01'),
(1, 'El Khattabi', 'Sarah', 'sarah.elkhattabi@example.com', '1000000002', 'ACTIF', '2000-02-01'),
(1, 'Moujahid', 'Youssef', 'youssef.moujahid@example.com', '1000000003', 'ACTIF', '2000-03-01'),
(2, 'Benali', 'Nadia', 'nadia.benali@example.com', '1000000004', 'ACTIF', '1975-01-01'),
(2, 'Haddadi', 'Karim', 'karim.haddadi@example.com', '1000000005', 'ACTIF', '1975-02-01'),
(2, 'Touhami', 'Salima', 'salima.touhami@example.com', '1000000006', 'ACTIF', '1975-03-01'),
(3, 'El Mansouri', 'Rachid', 'rachid.elmansouri@example.com', '1000000007', 'ACTIF', '1980-01-01'),
(3, 'Zerouali', 'Amina', 'amina.zerouali@example.com', '1000000008', 'ACTIF', '1980-02-01');

-- Insérer les données dans la table User
INSERT INTO User (email, mot_de_passe, role, id_adherent) VALUES
('amine.bensaid@example.com', 'etu001', 'ADHERENT', 1),
('sarah.elkhattabi@example.com', 'etu002', 'ADHERENT', 2),
('youssef.moujahid@example.com', 'etu003', 'ADHERENT', 3),
('nadia.benali@example.com', 'ens001', 'ADHERENT', 4),
('karim.haddadi@example.com', 'ens002', 'ADHERENT', 5),
('salima.touhami@example.com', 'ens003', 'ADHERENT', 6),
('rachid.elmansouri@example.com', 'prof001', 'ADHERENT', 7),
('amina.zerouali@example.com', 'prof002', 'ADHERENT', 8);

INSERT INTO User (email, mot_de_passe, role, id_adherent)
VALUES ('bibliothecaire@example.com', 'bibli1', 'BIBLIOTHECAIRE', NULL);

-- Insérer les données dans la table Abonnement
INSERT INTO Abonnement (id_adherent, date_debut, date_fin, montant, statut) VALUES
(1, '2025-02-01', '2025-07-24', 50.00, 'ACTIVE'), -- OK
(2, '2025-02-01', '2025-07-01', 50.00, 'EXPIREE'), -- KO
(3, '2025-04-01', '2025-12-01', 50.00, 'ACTIVE'), -- OK
(4, '2025-07-01', '2026-07-01', 70.00, 'ACTIVE'), -- OK
(5, '2025-08-01', '2026-05-01', 70.00, 'EXPIREE'), -- KO
(6, '2025-07-01', '2026-06-01', 70.00, 'ACTIVE'), -- OK
(7, '2025-06-01', '2025-12-01', 80.00, 'ACTIVE'), -- OK
(8, '2024-10-01', '2025-06-01', 80.00, 'EXPIREE'); -- KO



-- Insérer les données dans la table Livre
INSERT INTO Livre (titre, auteur, isbn, genre, annee_publication) VALUES
('Les Misérables', 'Victor Hugo', '9782070409189', 'Littérature classique', 1862),
('L\'Étranger', 'Albert Camus', '9782070360022', 'Philosophie', 1942),
('Harry Potter à l\'école des sorciers', 'J.K. Rowling', '9782070643026', 'Jeunesse / Fantastique', 1997);

-- Insérer les données dans la table Exemplaire
INSERT INTO Exemplaire (id_livre, etat, statut) VALUES
(1, 'BON', 'DISPONIBLE'), -- MIS001
(1, 'BON', 'DISPONIBLE'), -- MIS002
(1, 'BON', 'DISPONIBLE'), -- MIS003
(2, 'BON', 'DISPONIBLE'), -- ETR001
(2, 'BON', 'DISPONIBLE'), -- ETR002
(3, 'BON', 'DISPONIBLE'); -- HAR001

-- Insérer les données dans la table jour_ferie
INSERT INTO jour_ferie (date_ferie, description, regle_rendu) VALUES
('2025-07-13', 'Jour férié', 'AVANT'),
('2025-07-26', 'Jour férié', 'AVANT'),
('2025-07-20', 'Jour férié', 'AVANT'),
('2025-07-27', 'Jour férié', 'AVANT'),
('2025-08-03', 'Jour férié', 'AVANT'),
('2025-08-10', 'Jour férié', 'AVANT'),
('2025-08-17', 'Jour férié', 'AVANT');

-- Ajouter des pénalités (simulées sans prêts spécifiques pour l'instant)
INSERT INTO Penalite (id_adherent, date_debut_penalite, date_fin_penalite, raison) VALUES
(1, '2025-07-16', DATE_ADD('2025-07-16', INTERVAL 10 DAY), 'Retard'),
(2, '2025-07-16', DATE_ADD('2025-07-16', INTERVAL 10 DAY), 'Retard'),
(3, '2025-07-16', DATE_ADD('2025-07-16', INTERVAL 10 DAY), 'Retard'),
(4, '2025-07-16', DATE_ADD('2025-07-16', INTERVAL 9 DAY), 'Retard'),
(5, '2025-07-16', DATE_ADD('2025-07-16', INTERVAL 9 DAY), 'Retard'),
(6, '2025-07-16', DATE_ADD('2025-07-16', INTERVAL 9 DAY), 'Retard'),
(7, '2025-07-16', DATE_ADD('2025-07-16', INTERVAL 8 DAY), 'Retard'),
(8, '2025-07-16', DATE_ADD('2025-07-16', INTERVAL 8 DAY), 'Retard');

-- Mettre à jour les statuts des adhérents avec des sanctions basées sur les pénalités
UPDATE Adherent a
JOIN Penalite p ON a.id_adherent = p.id_adherent
SET a.statut = 'SANCTIONNE', a.date_fin_sanction = p.date_fin_penalite
WHERE p.date_fin_penalite > '2025-07-16';

-- Mettre à jour les quotas restants des adhérents
UPDATE Adherent a
JOIN Profil p ON a.id_profil = p.id_profil
SET a.quotat_restant = p.quota_pret;

 select * from pret; 

