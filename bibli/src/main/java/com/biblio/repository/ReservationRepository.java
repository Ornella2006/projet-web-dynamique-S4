package com.biblio.repository;

import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.Reservation;
import com.biblio.model.Reservation.Statut;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ReservationRepository extends JpaRepository<Reservation, Integer> {
    @Query("SELECT COUNT(r) FROM Reservation r WHERE r.adherent = :adherent AND r.statut NOT IN :statuts")
    long countByAdherentAndStatutNotIn(@Param("adherent") Adherent adherent, @Param("statuts") List<Statut> statuts);

    @Query("SELECT r FROM Reservation r WHERE r.statut = :statut")
    List<Reservation> findByStatut(@Param("statut") Statut statut);

    @Query("SELECT CASE WHEN COUNT(r) > 0 THEN true ELSE false END FROM Reservation r WHERE r.exemplaire = :exemplaire AND r.statut = :statut")
    boolean existsByExemplaireAndStatut(@Param("exemplaire") Exemplaire exemplaire, @Param("statut") Statut statut);
}