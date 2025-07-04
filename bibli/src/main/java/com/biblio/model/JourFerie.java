package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "JourFerie")
public class JourFerie {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idJourFerie;

    @Column(nullable = false, unique = true)
    private LocalDate dateFerie;

    private String description;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private RegleRendu regleRendu = RegleRendu.AVANT;

    public enum RegleRendu {
        AVANT, APRES
    }

    // Getters and Setters
    public int getIdJourFerie() { return idJourFerie; }
    public void setIdJourFerie(int idJourFerie) { this.idJourFerie = idJourFerie; }
    public LocalDate getDateFerie() { return dateFerie; }
    public void setDateFerie(LocalDate dateFerie) { this.dateFerie = dateFerie; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public RegleRendu getRegleRendu() { return regleRendu; }
    public void setRegleRendu(RegleRendu regleRendu) { this.regleRendu = regleRendu; }
}