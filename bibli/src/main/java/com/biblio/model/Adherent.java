package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "adherent")
public class Adherent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nom;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TypeAdherent type;

    @Column(nullable = false)
    private boolean actif = true;

    @Column(nullable = false)
    private int quotaPret = 3;

    private LocalDate dateExpirationAbonnement;

    // Enum pour le type d'adhérent
    public enum TypeAdherent {
        ETUDIANT, PROFESSIONNEL, PROFESSEUR
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public TypeAdherent getType() { return type; }
    public void setType(TypeAdherent type) { this.type = type; }
    public boolean isActif() { return actif; }
    public void setActif(boolean actif) { this.actif = actif; }
    public int getQuotaPret() { return quotaPret; }
    public void setQuotaPret(int quotaPret) { this.quotaPret = quotaPret; }
    public LocalDate getDateExpirationAbonnement() { return dateExpirationAbonnement; }
    public void setDateExpirationAbonnement(LocalDate dateExpirationAbonnement) {
        this.dateExpirationAbonnement = dateExpirationAbonnement;
    }
}