package com.biblio.repository;

import com.biblio.model.Exemplaire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ExemplaireRepository extends JpaRepository<Exemplaire, Integer> {
    @Query("SELECT e FROM Exemplaire e JOIN FETCH e.livre")
    List<Exemplaire> findAllWithLivre();

    // @Query("SELECT e FROM Exemplaire e JOIN FETCH e.livre WHERE e.statut = 'DISPONIBLE'")
// List<Exemplaire> findAllWithLivre();
}