-- temporary
UPDATE Abonnement SET statut = 'ACTIVE' WHERE id_abonnement = 1;

UPDATE Adherent SET statut = 'ACTIF' WHERE id_adherent = 1;
UPDATE Adherent SET date_fin_sanction = NULL WHERE id_adherent = 1;

UPDATE Exemplaire SET statut = 'DISPONIBLE' WHERE id_exemplaire = 1;

UPDATE livre SET restriction_age = 0 WHERE id_livre = 1;






UPDATE Adherent a
SET a.quotat_restant = (SELECT p.quota_pret FROM Profil p WHERE p.id_profil = a.id_profil)
WHERE a.quotat_restant IS NULL OR a.quotat_restant != (SELECT p.quota_pret FROM Profil p WHERE p.id_profil = a.id_profil);

DROP TRIGGER IF EXISTS set_default_quotat_restant;