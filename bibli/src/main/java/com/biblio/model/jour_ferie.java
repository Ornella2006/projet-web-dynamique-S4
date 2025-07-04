package com.biblio.model;

import java.time.LocalDate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "jour_ferie") // Spécifie le nom exact de la table
public class jour_ferie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_jourferie")
    private int idJourFerie;

    @Column(name = "date_ferie", nullable = false, unique = true)
    private LocalDate dateFerie;

    @Column(name = "description")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "regle_rendu")
    private RegleRendu regleRendu;

    public enum RegleRendu {
        AVANT, APRES
    }

    // Constructeurs
    public jour_ferie() {}

    public jour_ferie(LocalDate dateFerie, String description, RegleRendu regleRendu) {
        this.dateFerie = dateFerie;
        this.description = description;
        this.regleRendu = regleRendu;
    }

    // Getters et Setters
    public int getIdJourFerie() {
        return idJourFerie;
    }

    public void setIdJourFerie(int idJourFerie) {
        this.idJourFerie = idJourFerie;
    }

    public LocalDate getDateFerie() {
        return dateFerie;
    }

    public void setDateFerie(LocalDate dateFerie) {
        this.dateFerie = dateFerie;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public RegleRendu getRegleRendu() {
        return regleRendu;
    }

    public void setRegleRendu(RegleRendu regleRendu) {
        this.regleRendu = regleRendu;
    }
}