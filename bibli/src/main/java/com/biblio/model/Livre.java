package com.biblio.model;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "livre")
public class Livre {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String titre;

    private String auteur;

    @Column(nullable = false, unique = true)
    private String isbn;

    @OneToMany(mappedBy = "livre", cascade = CascadeType.ALL)
    private List<Exemplaire> exemplaires;

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }
    public String getAuteur() { return auteur; }
    public void setAuteur(String auteur) { this.auteur = auteur; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public List<Exemplaire> getExemplaires() { return exemplaires; }
    public void setExemplaires(List<Exemplaire> exemplaires) { this.exemplaires = exemplaires; }
}