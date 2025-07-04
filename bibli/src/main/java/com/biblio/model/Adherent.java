package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "Adherent")
public class Adherent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idAdherent;

    @ManyToOne
    @JoinColumn(name = "id_profil", nullable = false)
    private Profil profil;

    @Column(nullable = false)
    private String nom;

    @Column(nullable = false)
    private String prenom;

    @Column(unique = true)
    private String email;

    private String telephone;

    @Column(nullable = false)
    private String motDePasse;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutAdherent statut = StatutAdherent.ACTIF;

    @Column(nullable = false)
    private LocalDate dateNaissance;

    public enum StatutAdherent {
        ACTIF, INACTIF, SANCTIONNE
    }

    // Getters and Setters
    public int getIdAdherent() { return idAdherent; }
    public void setIdAdherent(int idAdherent) { this.idAdherent = idAdherent; }
    public Profil getProfil() { return profil; }
    public void setProfil(Profil profil) { this.profil = profil; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }
    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }
    public StatutAdherent getStatut() { return statut; }
    public void setStatut(StatutAdherent statut) { this.statut = statut; }
    public LocalDate getDateNaissance() { return dateNaissance; }
    public void setDateNaissance(LocalDate dateNaissance) { this.dateNaissance = dateNaissance; }
}