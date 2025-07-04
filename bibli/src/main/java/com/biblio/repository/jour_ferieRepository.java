package com.biblio.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.biblio.model.jour_ferie;

public interface jour_ferieRepository extends JpaRepository<jour_ferie, Integer> {
    List<jour_ferie> findByDateFerieBetween(LocalDate startDate, LocalDate endDate);
}