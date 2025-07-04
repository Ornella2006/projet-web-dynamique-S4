package com.biblio.repository;

import com.biblio.model.JourFerie;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface JourFerieRepository extends JpaRepository<JourFerie, Integer> {
    List<JourFerie> findByDateFerieBetween(LocalDate start, LocalDate end);
}