package com.biblio.model;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "Pret")
public class Pret {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idPret;

    @ManyToOne
    @JoinColumn(name = "id_exemplaire", nullable = false)
    private Exemplaire exemplaire;

    @ManyToOne
    @JoinColumn(name = "id_adherent", nullable = false)
    private Adherent adherent;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TypePret typePret;

    @Column(nullable = false)
    private LocalDateTime datePret;

    @Column(nullable = false)
    private LocalDateTime dateRetourPrevue;

    private LocalDateTime dateRetourEffective;

    @Column(nullable = false)
    private int prolongationCount = 0;

    public enum TypePret {
        DOMICILE, SUR_PLACE
    }

    // Getters and Setters
    public int getIdPret() { return idPret; }
    public void setIdPret(int idPret) { this.idPret = idPret; }
    public Exemplaire getExemplaire() { return exemplaire; }
    public void setExemplaire(Exemplaire exemplaire) { this.exemplaire = exemplaire; }
    public Adherent getAdherent() { return adherent; }
    public void setAdherent(Adherent adherent) { this.adherent = adherent; }
    public TypePret getTypePret() { return typePret; }
    public void setTypePret(TypePret typePret) { this.typePret = typePret; }
    public LocalDateTime getDatePret() { return datePret; }
    public void setDatePret(LocalDateTime datePret) { this.datePret = datePret; }
    public LocalDateTime getDateRetourPrevue() { return dateRetourPrevue; }
    public void setDateRetourPrevue(LocalDateTime dateRetourPrevue) { this.dateRetourPrevue = dateRetourPrevue; }
    public LocalDateTime getDateRetourEffective() { return dateRetourEffective; }
    public void setDateRetourEffective(LocalDateTime dateRetourEffective) { this.dateRetourEffective = dateRetourEffective; }
    public int getProlongationCount() { return prolongationCount; }
    public void setProlongationCount(int prolongationCount) { this.prolongationCount = prolongationCount; }
}