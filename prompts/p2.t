mais vous ne m'avez jamais fourni de vue pretResult seulement pretForm et aussi voici tous les contenus de code que vous m'avez fourni pour ce PreterLivre :
main/java/com/biblio/
controller/
PretController.java :
package com.biblio.controller;

import com.biblio.exception.PretException;
import com.biblio.service.PretService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PretController {

    @Autowired
    private PretService pretService;

    @GetMapping("/pret")
    public String showPretForm(Model model) {
        model.addAttribute("typesPret", new String[]{"DOMICILE", "SUR_PLACE"});
        return "pretForm";
    }

    @PostMapping("/pret")
    public String preterExemplaire(
            @RequestParam("idAdherent") int idAdherent,
            @RequestParam("idExemplaire") int idExemplaire,
            @RequestParam("typePret") String typePret,
            Model model) {
        try {
            pretService.preterExemplaire(idAdherent, idExemplaire, typePret);
            model.addAttribute("message", "Prêt effectué avec succès.");
        } catch (PretException e) {
            model.addAttribute("error", e.getMessage());
        }
        model.addAttribute("typesPret", new String[]{"DOMICILE", "SUR_PLACE"});
        return "pretForm";
    }
}

exception/
PretException.java :
package com.biblio.exception;

public class PretException extends RuntimeException {
    public PretException(String message) {
        super(message);
    }
}

model/
Abonnement.java :
package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "Abonnement")
public class Abonnement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idAbonnement;

    @ManyToOne
    @JoinColumn(name = "id_adherent", nullable = false)
    private Adherent adherent;

    @Column(nullable = false)
    private LocalDate dateDebut;

    @Column(nullable = false)
    private LocalDate dateFin;

    @Column(nullable = false)
    private double montant;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutAbonnement statut = StatutAbonnement.ACTIVE;

    public enum StatutAbonnement {
        ACTIVE, EXPIREE
    }

    // Getters and Setters
    public int getIdAbonnement() { return idAbonnement; }
    public void setIdAbonnement(int idAbonnement) { this.idAbonnement = idAbonnement; }
    public Adherent getAdherent() { return adherent; }
    public void setAdherent(Adherent adherent) { this.adherent = adherent; }
    public LocalDate getDateDebut() { return dateDebut; }
    public void setDateDebut(LocalDate dateDebut) { this.dateDebut = dateDebut; }
    public LocalDate getDateFin() { return dateFin; }
    public void setDateFin(LocalDate dateFin) { this.dateFin = dateFin; }
    public double getMontant() { return montant; }
    public void setMontant(double montant) { this.montant = montant; }
    public StatutAbonnement getStatut() { return statut; }
    public void setStatut(StatutAbonnement statut) { this.statut = statut; }
}

Adherent.java :
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

Exemplaire.java :
package com.biblio.model;

import javax.persistence.*;

@Entity
@Table(name = "Exemplaire")
public class Exemplaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idExemplaire;

    @ManyToOne
    @JoinColumn(name = "id_livre", nullable = false)
    private Livre livre;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private EtatExemplaire etat = EtatExemplaire.BON;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutExemplaire statut = StatutExemplaire.DISPONIBLE;

    public enum EtatExemplaire {
        BON, ABIME, PERDU
    }

    public enum StatutExemplaire {
        DISPONIBLE, EN_PRET, RESERVE, LECTURE_SUR_PLACE
    }

    // Getters and Setters
    public int getIdExemplaire() { return idExemplaire; }
    public void setIdExemplaire(int idExemplaire) { this.idExemplaire = idExemplaire; }
    public Livre getLivre() { return livre; }
    public void setLivre(Livre livre) { this.livre = livre; }
    public EtatExemplaire getEtat() { return etat; }
    public void setEtat(EtatExemplaire etat) { this.etat = etat; }
    public StatutExemplaire getStatut() { return statut; }
    public void setStatut(StatutExemplaire statut) { this.statut = statut; }
}

JourFerie.java :
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

Livre.java :
package com.biblio.model;

import javax.persistence.*;

@Entity
@Table(name = "Livre")
public class Livre {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idLivre;

    @Column(nullable = false)
    private String titre;

    private String auteur;

    private String editeur;

    private Integer anneePublication;

    private String genre;

    @Column(unique = true)
    private String isbn;

    private int restrictionAge = 0;

    private boolean professeurSeulement = false;

    // Getters and Setters
    public int getIdLivre() { return idLivre; }
    public void setIdLivre(int idLivre) { this.idLivre = idLivre; }
    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }
    public String getAuteur() { return auteur; }
    public void setAuteur(String auteur) { this.auteur = auteur; }
    public String getEditeur() { return editeur; }
    public void setEditeur(String editeur) { this.editeur = editeur; }
    public Integer getAnneePublication() { return anneePublication; }
    public void setAnneePublication(Integer anneePublication) { this.anneePublication = anneePublication; }
    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public int getRestrictionAge() { return restrictionAge; }
    public void setRestrictionAge(int restrictionAge) { this.restrictionAge = restrictionAge; }
    public boolean isProfesseurSeulement() { return professeurSeulement; }
    public void setProfesseurSeulement(boolean professeurSeulement) { this.professeurSeulement = professeurSeulement; }
}

Pret.java :
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

Profil.java :
package com.biblio.model;

import javax.persistence.*;

@Entity
@Table(name = "Profil")
public class Profil {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idProfil;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TypeProfil typeProfil;

    @Column(nullable = false)
    private int dureePret;

    @Column(nullable = false)
    private int quotaPret;

    @Column(nullable = false)
    private int quotaProlongement;

    @Column(nullable = false)
    private int quotaReservation;

    @Column(nullable = false)
    private int dureePenalite;

    public enum TypeProfil {
        ETUDIANT, PROFESSEUR, PROFESSIONNEL
    }

    // Getters and Setters
    public int getIdProfil() { return idProfil; }
    public void setIdProfil(int idProfil) { this.idProfil = idProfil; }
    public TypeProfil getTypeProfil() { return typeProfil; }
    public void setTypeProfil(TypeProfil typeProfil) { this.typeProfil = typeProfil; }
    public int getDureePret() { return dureePret; }
    public void setDureePret(int dureePret) { this.dureePret = dureePret; }
    public int getQuotaPret() { return quotaPret; }
    public void setQuotaPret(int quotaPret) { this.quotaPret = quotaPret; }
    public int getQuotaProlongement() { return quotaProlongement; }
    public void setQuotaProlongement(int quotaProlongement) { this.quotaProlongement = quotaProlongement; }
    public int getQuotaReservation() { return quotaReservation; }
    public void setQuotaReservation(int quotaReservation) { this.quotaReservation = quotaReservation; }
    public int getDureePenalite() { return dureePenalite; }
    public void setDureePenalite(int dureePenalite) { this.dureePenalite = dureePenalite; }
}

repository/ :
AbonnementRepositoy.java :
package com.biblio.repository;

import com.biblio.model.Abonnement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDate;

public interface AbonnementRepository extends JpaRepository<Abonnement, Integer> {
    @Query("SELECT a FROM Abonnement a WHERE a.adherent.idAdherent = :adherentId AND a.statut = 'ACTIVE' AND a.dateDebut <= :currentDate AND a.dateFin >= :currentDate")
    Abonnement findActiveAbonnementByAdherent(int adherentId, LocalDate currentDate);
}

AdherentRepository.java :
package com.biblio.repository;

import com.biblio.model.Adherent;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdherentRepository extends JpaRepository<Adherent, Integer> {
}

ExemplaireRepository.java :
package com.biblio.repository;

import com.biblio.model.Exemplaire;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ExemplaireRepository extends JpaRepository<Exemplaire, Integer> {
}


JourFerieRepository.java :
package com.biblio.repository;

import com.biblio.model.JourFerie;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface JourFerieRepository extends JpaRepository<JourFerie, Integer> {
    List<JourFerie> findByDateFerieBetween(LocalDate start, LocalDate end);
}

PretRepository.java :
package com.biblio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.biblio.model.Pret;

public interface PretRepository extends JpaRepository<Pret, Integer> {
    @Query("SELECT COUNT(p) FROM Pret p WHERE p.adherent.idAdherent = :idAdherent AND p.dateRetourEffective IS NULL")
    long countActivePretsByAdherent(@Param("idAdherent") int idAdherent);
}


service/
PretService.java :
package com.biblio.service;

import com.biblio.exception.PretException;
import com.biblio.model.*;
import com.biblio.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class PretService {

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private JourFerieRepository jourFerieRepository;

    @Transactional
    public void preterExemplaire(int idAdherent, int idExemplaire, String typePret) {
        // Valider l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));

        // Vérifier le statut de l'adhérent
        if (adherent.getStatut() == Adherent.StatutAdherent.SANCTIONNE) {
            throw new PretException("L'adhérent est sous sanction.");
        }

        // Vérifier l'abonnement actif
        LocalDate currentDate = LocalDate.now();
        Abonnement abonnement = abonnementRepository.findActiveAbonnementByAdherent(idAdherent, currentDate);
        if (abonnement == null) {
            throw new PretException("Aucun abonnement actif trouvé pour cet adhérent.");
        }

        // Vérifier l'exemplaire
        Exemplaire exemplaire = exemplaireRepository.findById(idExemplaire)
                .orElseThrow(() -> new PretException("L'exemplaire n'existe pas."));
        if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
            throw new PretException("L'exemplaire n'est pas disponible.");
        }

        // Vérifier la restriction d'âge
        int age = LocalDate.now().getYear() - adherent.getDateNaissance().getYear();
        if (exemplaire.getLivre().getRestrictionAge() > age) {
            throw new PretException("L'adhérent ne satisfait pas à la restriction d'âge.");
        }

        // Vérifier la restriction professeur
        if (exemplaire.getLivre().isProfesseurSeulement() && adherent.getProfil().getTypeProfil() != Profil.TypeProfil.PROFESSEUR) {
            throw new PretException("Livre réservé aux professeurs.");
        }

        // Vérifier le quota de prêts
        long activePrets = pretRepository.countActivePretsByAdherent(idAdherent);
        if (activePrets >= adherent.getProfil().getQuotaPret()) {
            throw new PretException("L'adhérent a atteint son quota de prêts.");
        }

        // Calculer la date de retour prévue
        LocalDateTime datePret = LocalDateTime.now();
        LocalDateTime dateRetourPrevue = datePret.plusDays(adherent.getProfil().getDureePret());

        // Vérifier les jours fériés
        List<JourFerie> joursFeries = jourFerieRepository.findByDateFerieBetween(
                datePret.toLocalDate(), dateRetourPrevue.toLocalDate());
        for (JourFerie jour : joursFeries) {
            if (jour.getRegleRendu() == JourFerie.RegleRendu.AVANT
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.minusDays(1);
            } else if (jour.getRegleRendu() == JourFerie.RegleRendu.APRES
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.plusDays(1);
            }
        }

        // Créer le prêt
        Pret pret = new Pret();
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        pret.setTypePret(Pret.TypePret.valueOf(typePret.toUpperCase()));
        pret.setDatePret(datePret);
        pret.setDateRetourPrevue(dateRetourPrevue);

        // Mettre à jour le statut de l'exemplaire
        exemplaire.setStatut(Pret.TypePret.valueOf(typePret.toUpperCase()) == Pret.TypePret.DOMICILE
                ? Exemplaire.StatutExemplaire.EN_PRET
                : Exemplaire.StatutExemplaire.LECTURE_SUR_PLACE);

        // Enregistrer les changements
        pretRepository.save(pret);
        exemplaireRepository.save(exemplaire);
    }
}

Dans java/com/biblio/Application.java :
package com.biblio;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = "com.biblio")
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}


dans resources/templates/rien aucun fichier html
application.properties :
     spring.datasource.url=jdbc:mysql://localhost:3306/gestion_bibliotheque?useSSL=false&serverTimezone=UTC
     spring.datasource.username=root
     spring.datasource.password=
     spring.jpa.hibernate.ddl-auto=none
     spring.jpa.show-sql=true
     spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
     spring.mvc.view.prefix=/WEB-INF/views/
     spring.mvc.view.suffix=.jsp
     server.port=8081
     spring.jpa.open-in-view=false


dans webapp/WEB-INF/views/index.jsp :
pretForm.jsp seulement :
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Formulaire de prêt</title>
</head>
<body>
    <h2>Formulaire de prêt</h2>
    <form action="/pret" method="post">
        <label for="idAdherent">ID Adhérent:</label>
        <input type="number" id="idAdherent" name="idAdherent" required><br>
        <label for="idExemplaire">ID Exemplaire:</label>
        <input type="number" id="idExemplaire" name="idExemplaire" required><br>
        <label for="typePret">Type de prêt:</label>
        <select id="typePret" name="typePret">
            <option value="DOMICILE">Domicile</option>
            <option value="SALLE">Salle</option>
        </select><br>
        <input type="submit" value="Valider le prêt">
    </form>
    <c:if test="${not empty message}">
        <p style="color: red;">${message}</p>
    </c:if>
</body>
</html>

test/java/com/biblio/service/PretServiceTest.java :
package com.biblio.service;

import java.time.LocalDate;
import java.util.Collections;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import org.mockito.MockitoAnnotations;

import com.biblio.exception.PretException;
import com.biblio.model.Abonnement;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.Livre;
import com.biblio.model.Pret;
import com.biblio.model.Profil;
import com.biblio.repository.AbonnementRepository;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.JourFerieRepository;
import com.biblio.repository.PretRepository;

public class PretServiceTest {

    @Mock
    private AdherentRepository adherentRepository;

    @Mock
    private ExemplaireRepository exemplaireRepository;

    @Mock
    private PretRepository pretRepository;

    @Mock
    private AbonnementRepository abonnementRepository;

    @Mock
    private JourFerieRepository jourFerieRepository;

    @InjectMocks
    private PretService pretService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testPreterExemplaireSuccess() {
        Adherent adherent = new Adherent();
        adherent.setIdAdherent(1);
        adherent.setStatut(Adherent.StatutAdherent.ACTIF);
        adherent.setDateNaissance(LocalDate.of(2000, 1, 1));
        Profil profil = new Profil();
        profil.setQuotaPret(3);
        profil.setDureePret(7);
        profil.setTypeProfil(Profil.TypeProfil.ETUDIANT);
        adherent.setProfil(profil);

        Exemplaire exemplaire = new Exemplaire();
        exemplaire.setIdExemplaire(1);
        exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);
        Livre livre = new Livre();
        livre.setRestrictionAge(0);
        livre.setProfesseurSeulement(false);
        exemplaire.setLivre(livre);

        Abonnement abonnement = new Abonnement();
        abonnement.setStatut(Abonnement.StatutAbonnement.ACTIVE);
        abonnement.setDateDebut(LocalDate.now().minusDays(10));
        abonnement.setDateFin(LocalDate.now().plusDays(10));

        when(adherentRepository.findById(eq(1))).thenReturn(Optional.of(adherent));
        when(exemplaireRepository.findById(eq(1))).thenReturn(Optional.of(exemplaire));
        when(abonnementRepository.findActiveAbonnementByAdherent(eq(1), any(LocalDate.class))).thenReturn(abonnement);
        when(pretRepository.countActivePretsByAdherent(eq(1))).thenReturn(0L);
        when(jourFerieRepository.findByDateFerieBetween(any(LocalDate.class), any(LocalDate.class))).thenReturn(Collections.emptyList());

        pretService.preterExemplaire(1, 1, "DOMICILE");

        verify(pretRepository, times(1)).save(any(Pret.class));
        verify(exemplaireRepository, times(1)).save(exemplaire);
        assertEquals(Exemplaire.StatutExemplaire.EN_PRET, exemplaire.getStatut());
    }

    @Test
    public void testPreterExemplaireAdherentNonExistant() {
        when(adherentRepository.findById(eq(1))).thenReturn(Optional.empty());
        PretException exception = assertThrows(PretException.class,
                () -> pretService.preterExemplaire(1, 1, "DOMICILE"));
        assertEquals("L'adhérent n'existe pas.", exception.getMessage());
    }
}


pom.xml :
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.biblio</groupId>
    <artifactId>bibli</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging> <!-- Changé de war à jar pour Spring Boot -->

    <properties>
        <java.version>11</java.version>
        <spring-boot.version>2.7.0</spring-boot.version>
        <maven.compiler.source>11</maven.compiler.source>
        <maven.compiler.target>11</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    </properties>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.0</version>
        <relativePath/>
    </parent>

    <dependencies>
        <!-- Spring Boot Starter Web (inclut Spring MVC et Tomcat embarqué) -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <!-- Spring Boot Starter Data JPA -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <!-- MySQL Connector -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.28</version>
        </dependency>
        <!-- JSTL pour JSP -->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>jstl</artifactId>
            <version>1.2</version>
        </dependency>
        <!-- Tomcat embarqué pour supporter JSP -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
            <scope>provided</scope>
        </dependency>
        <!-- Tomcat Jasper pour le rendu des JSP -->
        <dependency>
            <groupId>org.apache.tomcat</groupId>
            <artifactId>tomcat-jasper</artifactId>
            <version>9.0.50</version>
        </dependency>
        <!-- Spring Boot Starter Test -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <!-- Mockito -->
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-core</artifactId>
            <version>4.6.1</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-junit-jupiter</artifactId>
            <version>4.6.1</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <!-- Plugin Spring Boot -->
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <version>${spring-boot.version}</version>
                <executions>
                    <execution>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
            <!-- Maven Compiler Plugin -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.13.0</version>
                <configuration>
                    <source>11</source>
                    <target>11</target>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
