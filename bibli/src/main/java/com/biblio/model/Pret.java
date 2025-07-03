package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "pret")
public class Pret {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "adherent_id")
    private Adherent adherent;

    @ManyToOne
    @JoinColumn(name = "exemplaire_id")
    private Exemplaire exemplaire;

    @Column(nullable = false)
    private LocalDate datePret;

    @Column(nullable = false)
    private LocalDate dateRetourPrevu;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TypePret typePret;

    // Enum pour le type de prêt
    public enum TypePret {
        SUR_PLACE, MAISON
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Adherent getAdherent() { return adherent; }
    public void setAdherent(Adherent adherent) { this.adherent = adherent; }
    public Exemplaire getExemplaire() { return exemplaire; }
    public void setExemplaire(Exemplaire exemplaire) { this.exemplaire = exemplaire; }
    public LocalDate getDatePret() { return datePret; }
    public void setDatePret(LocalDate datePret) { this.datePret = datePret; }
    public LocalDate getDateRetourPrevu() { return dateRetourPrevu; }
    public void setDateRetourPrevu(LocalDate dateRetourPrevu) { this.dateRetourPrevu = dateRetourPrevu; }
    public TypePret getTypePret() { return typePret; }
    public void setTypePret(TypePret typePret) { this.typePret = typePret; }
}