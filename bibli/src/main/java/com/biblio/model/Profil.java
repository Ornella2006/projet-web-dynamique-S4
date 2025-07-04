package com.biblio.model;

import javax.persistence.*;

@Entity
@Table(name = "Profil")
public class Profil {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idProfil;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TypeProfil typeProfil;

    @Column(nullable = false)
    private int dureePret;

    @Column(nullable = false)
    private int quotaPret;

    @Column(nullable = false)
    private int quotaProlongement;

    @Column(nullable = false)
    private int quotaReservation;

    @Column(nullable = false)
    private int dureePenalite;

    public Profil() {
    }

    public Profil(Integer idProfil) {
        this.idProfil = idProfil;
    }

    public enum TypeProfil {
        ETUDIANT, PROFESSEUR, PROFESSIONNEL
    }

    // Getters and Setters
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