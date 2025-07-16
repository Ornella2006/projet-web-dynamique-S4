package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDate;
// import java.time.LocalDate;

@Entity
@Table(name = "Penalite")
public class Penalite {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_penalite")
    private int idPenalite;

    @ManyToOne
    @JoinColumn(name = "id_adherent", nullable = false)
    private Adherent adherent;

    @ManyToOne
    @JoinColumn(name = "id_pret")
    private Pret pret;

    @Column(name = "date_debut_penalite", nullable = false)
    private LocalDate dateDebutPenalite;

    @Column(name = "date_fin_penalite", nullable = false)
    private LocalDate dateFinPenalite;

    @Column(name = "raison")
    private String raison;

    // Constructeurs
    public Penalite() {}

    public Penalite(Adherent adherent, Pret pret, LocalDate dateDebutPenalite, LocalDate dateFinPenalite, String raison) {
        this.adherent = adherent;
        this.pret = pret;
        this.dateDebutPenalite = dateDebutPenalite;
        this.dateFinPenalite = dateFinPenalite;
        this.raison = raison;
    }

    // Getters et Setters
    public int getIdPenalite() { return idPenalite; }
    public void setIdPenalite(int idPenalite) { this.idPenalite = idPenalite; }
    public Adherent getAdherent() { return adherent; }
    public void setAdherent(Adherent adherent) { this.adherent = adherent; }
    public Pret getPret() { return pret; }
    public void setPret(Pret pret) { this.pret = pret; }
    public LocalDate getDateDebutPenalite() { return dateDebutPenalite; }
    public void setDateDebutPenalite(LocalDate dateDebutPenalite) { this.dateDebutPenalite = dateDebutPenalite; }
    public LocalDate getDateFinPenalite() { return dateFinPenalite; }
    public void setDateFinPenalite(LocalDate dateFinPenalite) { this.dateFinPenalite = dateFinPenalite; }
    public String getRaison() { return raison; }
    public void setRaison(String raison) { this.raison = raison; }
}