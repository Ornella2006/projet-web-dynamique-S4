package com.biblio.model;

   import java.time.LocalDate;
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
   @Table(name = "Reservation")
   public class Reservation {
       @Id
       @GeneratedValue(strategy = GenerationType.IDENTITY)
       @Column(name = "id_reservation")
       private int idReservation;

       @ManyToOne
       @JoinColumn(name = "id_exemplaire", nullable = false)
       private Exemplaire exemplaire;

       @ManyToOne
       @JoinColumn(name = "id_adherent", nullable = false)
       private Adherent adherent;

       @Column(name = "date_reservation", nullable = true)
       private LocalDate dateReservation;

       @Column(name = "date_retrait_prevue", nullable = true)
       private LocalDate dateRetraitPrevue;

       @Column(name = "date_expiration", nullable = true)
       private LocalDate dateExpiration;

       @Enumerated(EnumType.STRING)
       @Column(name = "statut", nullable = false)
       private Statut statut;

       @Enumerated(EnumType.STRING)
       @Column(name = "type_pret", nullable = false)
       private TypePret typePret; // Ajout du champ typePret

       // Constructeurs
       public Reservation() {}

       public Reservation(Exemplaire exemplaire, Adherent adherent, LocalDate dateReservation, LocalDate dateRetraitPrevue, LocalDate dateExpiration, TypePret typePret) {
           this.exemplaire = exemplaire;
           this.adherent = adherent;
           this.dateReservation = dateReservation;
           this.dateRetraitPrevue = dateRetraitPrevue;
           this.dateExpiration = dateExpiration;
           this.statut = Statut.EN_ATTENTE;
           this.typePret = typePret; // Initialisation du typePret
       }

       // Getters et Setters
       public int getIdReservation() { return idReservation; }
       public void setIdReservation(int idReservation) { this.idReservation = idReservation; }
       public Exemplaire getExemplaire() { return exemplaire; }
       public void setExemplaire(Exemplaire exemplaire) { this.exemplaire = exemplaire; }
       public Adherent getAdherent() { return adherent; }
       public void setAdherent(Adherent adherent) { this.adherent = adherent; }
       public LocalDate getDateReservation() { return dateReservation; }
       public void setDateReservation(LocalDate dateReservation) { this.dateReservation = dateReservation; }
       public LocalDate getDateRetraitPrevue() { return dateRetraitPrevue; }
       public void setDateRetraitPrevue(LocalDate dateRetraitPrevue) { this.dateRetraitPrevue = dateRetraitPrevue; }
       public LocalDate getDateExpiration() { return dateExpiration; }
       public void setDateExpiration(LocalDate dateExpiration) { this.dateExpiration = dateExpiration; }
       public Statut getStatut() { return statut; }
       public void setStatut(Statut statut) { this.statut = statut; }

       public TypePret getTypePret() { return typePret; } // Implémentation correcte
       public void setTypePret(TypePret typePret) { this.typePret = typePret; }

       public enum Statut {
           EN_ATTENTE, VALIDEE, ANNULEE, EXPIREE, CONVERTIE_EN_PRET
       }

       public enum TypePret {
           DOMICILE, SUR_PLACE
       }
   }