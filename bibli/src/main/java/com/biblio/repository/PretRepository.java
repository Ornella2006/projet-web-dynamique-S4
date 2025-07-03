package com.biblio.repository;

import com.biblio.model.Pret;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PretRepository extends JpaRepository<Pret, Long> {
}