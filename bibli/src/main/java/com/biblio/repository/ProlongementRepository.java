package com.biblio.repository;

import com.biblio.model.Adherent;
import com.biblio.model.Prolongement;
import com.biblio.model.Prolongement.StatutProlongement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

import javax.transaction.Transactional;

public interface ProlongementRepository extends JpaRepository<Prolongement, Integer> {
    @Query("SELECT COUNT(p) FROM Prolongement p WHERE p.adherent = :adherent AND p.statut = :statut")
    long countByAdherentAndStatut(@Param("adherent") Adherent adherent, @Param("statut") StatutProlongement statut);

     @Override
    @Transactional
    <S extends Prolongement> S save(S entity);
}