package com.biblio.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.biblio.model.Abonnement;

public interface CotisationRepository extends JpaRepository<Abonnement, Integer> {
}