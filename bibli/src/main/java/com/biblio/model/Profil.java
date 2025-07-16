package com.biblio.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "Profil")
public class Profil {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_profil")
    private int idProfil;

    @Enumerated(EnumType.STRING)
    @Column(name = "type_profil", nullable = false)
    private TypeProfil typeProfil;

    @Column(name = "duree_pret", nullable = false)
    private int dureePret;

    @Column(name = "quota_pret", nullable = false)
    private int quotaPret;

    @Column(name = "quota_prolongement", nullable = false)
    private int quotaProlongement;

    @Column(name = "quota_reservation", nullable = false)
    private int quotaReservation;

    @Column(name = "duree_penalite", nullable = false)
    private int dureePenalite;

    public enum TypeProfil {
        ETUDIANT, ENSEIGNANT, PROFESSIONNEL
    }

    // Constructeurs
    public Profil() {}

     public Profil(Integer idProfil) {
        this.idProfil = idProfil;
    }

    public Profil(int idProfil, TypeProfil typeProfil, int dureePret, int quotaPret, int quotaProlongement, int quotaReservation, int dureePenalite) {
        this.idProfil = idProfil;
        this.typeProfil = typeProfil;
        this.dureePret = dureePret;
        this.quotaPret = quotaPret;
        this.quotaProlongement = quotaProlongement;
        this.quotaReservation = quotaReservation;
        this.dureePenalite = dureePenalite;
    }

    // Getters et Setters
    public int getIdProfil() { return idProfil; }
    public void setIdProfil(int idProfil) { this.idProfil = idProfil; }
    public TypeProfil getTypeProfil() { return typeProfil; }
    public void setTypeProfil(TypeProfil typeProfil) { this.typeProfil = typeProfil; }
    public int getDureePret() { return dureePret; }
    public void setDureePret(int dureePret) { this.dureePret = dureePret; }
    public int getQuotaPret() { return quotaPret; }
    public void setQuotaPret(int quotaPret) { this.quotaPret = quotaPret; }
    public int getQuotaProlongement() { return quotaProlongement; }
    public void setQuotaProlongement(int quotaProlongement) { this.quotaProlongement = quotaProlongement; }
    public int getQuotaReservation() { return quotaReservation; }
    public void setQuotaReservation(int quotaReservation) { this.quotaReservation = quotaReservation; }
    public int getDureePenalite() { return dureePenalite; }
    public void setDureePenalite(int dureePenalite) { this.dureePenalite = dureePenalite; }
}