-- Mettre à jour les statuts des adhérents avec des sanctions basées sur les pénalités
UPDATE Adherent a
JOIN Penalite p ON a.id_adherent = p.id_adherent
SET a.statut = 'SANCTIONNE', a.date_fin_sanction = p.date_fin_penalite
WHERE p.date_fin_penalite > '2025-07-16';

-- Mettre à jour les quotas restants des adhérents
UPDATE Adherent a
JOIN Profil p ON a.id_profil = p.id_profil
SET a.quotat_restant = p.quota_pret;