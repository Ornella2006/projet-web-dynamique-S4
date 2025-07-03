package com.biblio.repository;

import com.biblio.model.Penalite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDate;
import java.util.List;

public interface PenaliteRepository extends JpaRepository<Penalite, Long> {
    @Query("SELECT p FROM Penalite p WHERE p.adherent.id = :adherentId AND p.dateFin >= :currentDate")
    List<Penalite> findActivePenalitesByAdherentId(Long adherentId, LocalDate currentDate);
}