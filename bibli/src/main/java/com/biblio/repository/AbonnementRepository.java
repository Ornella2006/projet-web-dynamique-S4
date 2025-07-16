package com.biblio.repository;

import com.biblio.model.Abonnement;
import com.biblio.model.Adherent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.Optional;

public interface AbonnementRepository extends JpaRepository<Abonnement, Integer> {
    @Query("SELECT a FROM Abonnement a WHERE a.adherent = :adherent AND a.statut = 'ACTIVE' AND a.dateFin >= :currentDate")
    Optional<Abonnement> findActiveAbonnementByAdherent(@Param("adherent") Adherent adherent, @Param("currentDate") LocalDate currentDate);

    @Query("SELECT COUNT(a) > 0 FROM Abonnement a WHERE a.adherent = :adherent AND a.dateFin > :currentDate")
    boolean existsByAdherentAndDateFinAfter(@Param("adherent") Adherent adherent, @Param("currentDate") LocalDate currentDate);

    // @Query("SELECT a FROM Abonnement a WHERE a.adherent = :adherent AND a.statut = 'ACTIVE' AND :date BETWEEN a.dateDebut AND a.dateFin")
    // Optional<Abonnement> findActiveAbonnementByAdherent(@Param("adherent") Adherent adherent, @Param("date") LocalDate date);
}