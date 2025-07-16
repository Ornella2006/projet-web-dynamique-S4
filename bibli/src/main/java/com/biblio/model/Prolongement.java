package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "Prolongement")
public class Prolongement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_prolongement")
    private int idProlongement;

    @ManyToOne
    @JoinColumn(name = "id_pret", nullable = false)
    private Pret pret;

    @Column(name = "date_demande_prolongement", nullable = false)
    private LocalDate dateDemandeProlongement;

    @Column(name = "nouvelle_date_retour", nullable = false)
    private LocalDate nouvelleDateRetour;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut", nullable = false)
    private StatutProlongement statut;

    @ManyToOne
    @JoinColumn(name = "id_adherent", nullable = false)
    private Adherent adherent;

    public enum StatutProlongement {
        EN_ATTENTE, VALIDE, REFUSE
    }

    // Constructeurs
    public Prolongement() {}

    public Prolongement(Pret pret, LocalDate dateDemandeProlongement, LocalDate nouvelleDateRetour, Adherent adherent) {
        this.pret = pret;
        this.dateDemandeProlongement = dateDemandeProlongement;
        this.nouvelleDateRetour = nouvelleDateRetour;
        this.adherent = adherent;
        this.statut = StatutProlongement.EN_ATTENTE;
    }

    // Getters et Setters
    public int getIdProlongement() { return idProlongement; }
    public void setIdProlongement(int idProlongement) { this.idProlongement = idProlongement; }
    public Pret getPret() { return pret; }
    public void setPret(Pret pret) { this.pret = pret; }
    public LocalDate getDateDemandeProlongement() { return dateDemandeProlongement; }
    public void setDateDemandeProlongement(LocalDate dateDemandeProlongement) { this.dateDemandeProlongement = dateDemandeProlongement; }
    public LocalDate getNouvelleDateRetour() { return nouvelleDateRetour; }
    public void setNouvelleDateRetour(LocalDate nouvelleDateRetour) { this.nouvelleDateRetour = nouvelleDateRetour; }
    public StatutProlongement getStatut() { return statut; }
    public void setStatut(StatutProlongement statut) { this.statut = statut; }
    public Adherent getAdherent() { return adherent; }
    public void setAdherent(Adherent adherent) { this.adherent = adherent; }
}