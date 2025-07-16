
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

INSERT INTO Profil (type_profil, duree_pret, quota_pret, quota_prolongement, quota_reservation, duree_penalite) VALUES
('Etudiant', 7, 3, 1, 2, 10),
('Professionnel', 14, 5, 2, 3, 15),
('Professeur', 30, 3, 3, 5, 7);


INSERT INTO Adherent (id_profil, nom, prenom, email, telephone, statut, date_naissance)
VALUES (1, 'Dupont', 'Jean', 'jean.dupont@example.com', '1234567890', 'ACTIF', '2000-01-01');

INSERT INTO Abonnement (id_adherent, date_debut, date_fin, montant, statut)
VALUES (1, '2025-06-01', '2026-06-01', 50.00, 'ACTIVE');

-- Insert reference data for profiles



INSERT INTO User (email, mot_de_passe, role, id_adherent)
VALUES ('jean.dupont@example.com', 'ad1', 'ADHERENT', 1);
INSERT INTO User (email, mot_de_passe, role, id_adherent)
VALUES ('bibliothecaire@example.com', 'bibli1', 'BIBLIOTHECAIRE', NULL);

-- donne de test reservation et recherche :
-- Ajout de livres supplémentaires
INSERT INTO Livre (titre, auteur, editeur, annee_publication, genre, isbn, restriction_age, professeur_seulement)
VALUES 
('Histoire du Monde', 'Marie Curie', 'Editions Universelles', 2018, 'Histoire', '9876543210987', 12, FALSE),
('Physique Quantique', 'Albert Einstein', 'Sciences Press', 2022, 'Science', '4567891234567', 16, TRUE),
('Roman d\'Amour', 'Jane Austen', 'Romantique Editions', 2019, 'Romance', '7891234567890', 0, FALSE);

-- Ajout d'exemplaires supplémentaires
INSERT INTO Exemplaire (id_livre, etat, statut)
VALUES 
(2, 'BON', 'DISPONIBLE'), -- Exemplaire pour "Histoire du Monde"
(2, 'ABIME', 'DISPONIBLE'), -- Deuxième exemplaire pour "Histoire du Monde"
(3, 'BON', 'DISPONIBLE'), -- Exemplaire pour "Physique Quantique"
(4, 'BON', 'DISPONIBLE'), -- Exemplaire pour "Roman d'Amour"
(4, 'BON', 'EN_PRET'); -- Deuxième exemplaire pour "Roman d'Amour" indisponible

-- Mise à jour des quotas restants pour les nouveaux adhérents (si ajoutés)
INSERT INTO Adherent (id_profil, nom, prenom, email, telephone, statut, date_naissance)
VALUES 
(2, 'Martin', 'Sophie', 'sophie.martin@example.com', '0987654321', 'ACTIF', '1995-05-15'),
(3, 'Leroy', 'Pierre', 'pierre.leroy@example.com', '1122334455', 'ACTIF', '1980-03-10');

INSERT INTO Abonnement (id_adherent, date_debut, date_fin, montant, statut)
VALUES 
(2, '2025-06-01', '2026-06-01', 60.00, 'ACTIVE'),
(3, '2025-06-01', '2026-06-01', 70.00, 'ACTIVE');

INSERT INTO User (email, mot_de_passe, role, id_adherent)
VALUES 
('sophie.martin@example.com', 'ad2', 'ADHERENT', 2),
('pierre.leroy@example.com', 'ad3', 'ADHERENT', 3);

 select * from pret; 