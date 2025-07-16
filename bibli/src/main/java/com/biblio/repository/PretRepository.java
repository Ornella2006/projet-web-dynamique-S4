package com.biblio.repository;

import com.biblio.model.Adherent;
import com.biblio.model.Pret;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PretRepository extends JpaRepository<Pret, Integer> {
    @Query("SELECT COUNT(p) FROM Pret p WHERE p.adherent.idAdherent = :idAdherent AND p.dateRetourEffective IS NULL")
    long countActivePretsByAdherent(@Param("idAdherent") int idAdherent);

    @Query("SELECT COUNT(p) FROM Pret p WHERE p.adherent = :adherent AND p.statut = :statut")
    long countByAdherentAndStatut(@Param("adherent") Adherent adherent, @Param("statut") Pret.Statut statut);

    @Query("SELECT COUNT(p) FROM Pret p WHERE p.adherent = :adherent AND p.statut NOT IN :statuts")
    long countByAdherentAndStatutNotIn(@Param("adherent") Adherent adherent, @Param("statuts") List<Pret.Statut> statuts);
}


