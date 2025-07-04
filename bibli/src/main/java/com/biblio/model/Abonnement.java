package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "Abonnement")
public class Abonnement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idAbonnement;

    @ManyToOne
    @JoinColumn(name = "id_adherent", nullable = false)
    private Adherent adherent;

    @Column(nullable = false)
    private LocalDate dateDebut;

    @Column(nullable = false)
    private LocalDate dateFin;

    @Column(nullable = false)
    private double montant;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutAbonnement statut = StatutAbonnement.ACTIVE;

    public enum StatutAbonnement {
        ACTIVE, EXPIREE
    }

    // Getters and Setters
    public int getIdAbonnement() { return idAbonnement; }
    public void setIdAbonnement(int idAbonnement) { this.idAbonnement = idAbonnement; }
    public Adherent getAdherent() { return adherent; }
    public void setAdherent(Adherent adherent) { this.adherent = adherent; }
    public LocalDate getDateDebut() { return dateDebut; }
    public void setDateDebut(LocalDate dateDebut) { this.dateDebut = dateDebut; }
    public LocalDate getDateFin() { return dateFin; }
    public void setDateFin(LocalDate dateFin) { this.dateFin = dateFin; }
    public double getMontant() { return montant; }
    public void setMontant(double montant) { this.montant = montant; }
    public StatutAbonnement getStatut() { return statut; }
    public void setStatut(StatutAbonnement statut) { this.statut = statut; }
}