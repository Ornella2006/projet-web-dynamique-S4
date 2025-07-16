-- Insérer les données initiales
INSERT INTO jour_ferie (date_ferie, description, regle_rendu) VALUES 
('2025-01-01', 'Jour de l\'An', 'AVANT'),
('2025-03-08', 'Journée internationale des femmes', 'AVANT'),
('2025-03-29', 'Commémoration des martyrs', 'AVANT'),
('2025-05-01', 'Fête du Travail', 'AVANT'),
('2025-06-26', 'Fête de l\'Indépendance', 'AVANT'),
('2025-08-15', 'Assomption', 'AVANT'),
('2025-11-01', 'Toussaint', 'AVANT'),
('2025-12-25', 'Noël', 'AVANT'),
('2025-04-18', 'Vendredi Saint', 'AVANT'),
('2025-04-20', 'Pâques', 'AVANT'),
('2025-05-29', 'Ascension', 'AVANT'),
('2025-06-08', 'Pentecôte', 'AVANT');

INSERT INTO Livre (titre, auteur, editeur, annee_publication, genre, isbn, restriction_age, professeur_seulement)
VALUES ('Livre Test', 'Auteur Test', 'Editeur Test', 2020, 'Fiction', '1234567890123', 0, FALSE);

INSERT INTO Exemplaire (id_livre, etat, statut)
VALUES (1, 'BON', 'DISPONIBLE');

INSERT INTO Profil (type_profil, duree_pret, quota_pret, quota_prolongement, quota_reservation, duree_penalite) VALUES
('ETUDIANT', 7, 3, 1, 2, 10),
('PROFESSIONNEL', 14, 5, 2, 3, 15),
('PROFESSEUR', 30, 3, 3, 5, 7);

INSERT INTO Adherent (id_profil, nom, prenom, email, telephone, statut, date_naissance)
VALUES (1, 'Dupont', 'Jean', 'jean.dupont@example.com', '1234567890', 'ACTIF', '2000-01-01');

INSERT INTO Abonnement (id_adherent, date_debut, date_fin, montant, statut)
VALUES (1, '2025-06-01', '2026-06-01', 50.00, 'ACTIVE');

INSERT INTO User (email, mot_de_passe, role, id_adherent)
VALUES ('jean.dupont@example.com', 'ad1', 'ADHERENT', 1),
('bibliothecaire@example.com', 'bibli1', 'BIBLIOTHECAIRE', NULL);