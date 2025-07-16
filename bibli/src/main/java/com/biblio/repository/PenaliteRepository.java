package com.biblio.repository;

import com.biblio.model.Adherent;
import com.biblio.model.Penalite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public interface PenaliteRepository extends JpaRepository<Penalite, Integer> {
    @Query("SELECT p FROM Penalite p WHERE p.adherent = :adherent AND p.dateFinPenalite > :date")
    List<Penalite> findByAdherentAndDateFinAfter(@Param("adherent") Adherent adherent, @Param("date") LocalDate date);
}