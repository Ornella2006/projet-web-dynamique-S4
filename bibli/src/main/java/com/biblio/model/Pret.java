package com.biblio.model;

import java.time.LocalDate;
// import java.time.LocalDate;

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

    @Column(name = "date_pret")
    private LocalDate datePret;

   @Column(name = "date_retour_prevue")
private LocalDate dateRetourPrevue;

    @Column(name = "date_retour_effective")
private LocalDate dateRetourEffective;

    @Column(nullable = false)
    private int prolongationCount = 0;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Statut statut = Statut.EN_COURS; // Par défaut, un prêt est en cours

    public enum TypePret {
        DOMICILE, SUR_PLACE
    }

    public enum Statut {
        EN_COURS, RETOURNE // Ajoutez d'autres états si nécessaire (par exemple, "EN_PROLONGATION")
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
    public LocalDate getDatePret() { return datePret; }

   public void setDatePret(LocalDate datePret) {
    this.datePret = datePret != null ? datePret : LocalDate.now();
}

    public LocalDate getDateRetourPrevue() { return dateRetourPrevue; }

    public void setDateRetourPrevue(LocalDate dateRetourPrevue) {
    this.dateRetourPrevue = dateRetourPrevue;
}

    public LocalDate getDateRetourEffective() { return dateRetourEffective; }
    
    public void setDateRetourEffective(LocalDate dateRetour) {
    this.dateRetourEffective = dateRetour;
}

    public int getProlongationCount() { return prolongationCount; }
    public void setProlongationCount(int prolongationCount) { this.prolongationCount = prolongationCount; }
    public Statut getStatut() { return statut; }
    public void setStatut(Statut statut) { this.statut = statut; }
}