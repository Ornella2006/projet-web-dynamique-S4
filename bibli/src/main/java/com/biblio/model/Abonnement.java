package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "Abonnement")
public class Abonnement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_abonnement")
    private Integer idAbonnement;

    @ManyToOne
    @JoinColumn(name = "id_adherent", nullable = false)
    private Adherent adherent;

    @Column(name = "date_debut", nullable = false)
    private LocalDate dateDebut;

    @Column(name = "date_fin", nullable = false)
    private LocalDate dateFin;

    @Column(name = "montant", nullable = false)
    private double montant;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut")
    private StatutAbonnement statut = StatutAbonnement.ACTIVE;

    public enum StatutAbonnement {
        ACTIVE, EXPIREE
    }

    // Getters et Setters
    public Integer getIdAbonnement() {
        return idAbonnement;
    }

    public void setIdAbonnement(Integer idAbonnement) {
        this.idAbonnement = idAbonnement;
    }

    public Adherent getAdherent() {
        return adherent;
    }

    public void setAdherent(Adherent adherent) {
        this.adherent = adherent;
    }

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    public LocalDate getDateFin() {
        return dateFin;
    }

    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public StatutAbonnement getStatut() {
        return statut;
    }

    public void setStatut(StatutAbonnement statut) {
        this.statut = statut;
    }
}