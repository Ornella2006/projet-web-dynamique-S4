package com.biblio.repository;

import com.biblio.model.Abonnement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDate;

public interface AbonnementRepository extends JpaRepository<Abonnement, Integer> {
    @Query("SELECT a FROM Abonnement a WHERE a.adherent.idAdherent = :adherentId AND a.statut = 'ACTIVE' AND a.dateDebut <= :currentDate AND a.dateFin >= :currentDate")
    Abonnement findActiveAbonnementByAdherent(int adherentId, LocalDate currentDate);
}