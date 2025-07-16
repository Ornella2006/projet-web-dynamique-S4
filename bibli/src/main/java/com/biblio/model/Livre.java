package com.biblio.model;

import javax.persistence.*;
import java.time.Year;

@Entity
@Table(name = "Livre")
public class Livre {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idLivre;

    @Column(nullable = false)
    private String titre;

    private String auteur;

    private String editeur;

    @Column(name = "annee_publication")
    private int anneePublication;

    private String genre;

    @Column(unique = true)
    private String isbn;

    @Column(name = "restriction_age", nullable = false)
    private int restrictionAge = 0;

    @Column(name = "ENSEIGNANT_seulement", nullable = false)
    private boolean ENSEIGNANTSeulement = false;

    // Getters and Setters
    public int getIdLivre() { return idLivre; }
    public void setIdLivre(int idLivre) { this.idLivre = idLivre; }
    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }
    public String getAuteur() { return auteur; }
    public void setAuteur(String auteur) { this.auteur = auteur; }
    public String getEditeur() { return editeur; }
    public void setEditeur(String editeur) { this.editeur = editeur; }
    public int getAnneePublication() { return anneePublication; }
    public void setAnneePublication(int anneePublication) { this.anneePublication = anneePublication; }
    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public int getRestrictionAge() { return restrictionAge; }
    public void setRestrictionAge(int restrictionAge) { this.restrictionAge = restrictionAge; }
    public boolean isENSEIGNANTSeulement() { return ENSEIGNANTSeulement; }
    public void setENSEIGNANTSeulement(boolean ENSEIGNANTSeulement) { this.ENSEIGNANTSeulement = ENSEIGNANTSeulement; }
  
}