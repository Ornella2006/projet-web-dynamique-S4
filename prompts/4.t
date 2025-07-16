dans controller :
AuthController :
package com.biblio.controller;

import java.time.LocalDate;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.biblio.model.Adherent;
import com.biblio.model.Profil;
import com.biblio.model.User;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.UserRepository;
import com.biblio.service.ReservationService;

@Controller
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private ReservationService reservationService;

    @GetMapping("/")
    public String showChoicePage() {
        return "choice";
    }

    @GetMapping("/login")
    public String showLoginPage(@RequestParam("role") String role, Model model) {
        model.addAttribute("role", role);
        return "login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam("email") String email,
                              @RequestParam("motDePasse") String motDePasse,
                              @RequestParam("role") String role,
                              Model model, HttpSession session) {
        try {
            User user = userRepository.findByEmail(email);
            if (user == null) {
                model.addAttribute("error", "Email incorrect.");
                model.addAttribute("role", role);
                return "login";
            }
            if (!user.getMotDePasse().equals(motDePasse)) {
                model.addAttribute("error", "Mot de passe incorrect.");
                model.addAttribute("role", role);
                return "login";
            }
            if (!user.getRole().toString().equals(role)) {
                model.addAttribute("error", "Rôle incorrect. Veuillez choisir le bon type de compte.");
                model.addAttribute("role", role);
                return "login";
            }
            session.setAttribute("user", user);
            if ("BIBLIOTHECAIRE".equals(role)) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/adherent/dashboard";
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Une erreur est survenue lors de la connexion. Veuillez réessayer.");
            model.addAttribute("role", role);
            return "login";
        }
    }

    @GetMapping("/admin/dashboard")
    public String showAdminDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.BIBLIOTHECAIRE) {
            return "redirect:/login?role=BIBLIOTHECAIRE";
        }
        return "adminDashboard";
    }

    @GetMapping("/adherent/dashboard")
    public String showAdherentDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.ADHERENT) {
            return "redirect:/login?role=ADHERENT";
        }
        return "adherentDashboard";
    }

    @GetMapping("/signin")
    public String showSigninPage(@RequestParam("role") String role, Model model) {
        model.addAttribute("role", role);
        return "signin";
    }

    @PostMapping("/signin")
    public String processSignin(@RequestParam("email") String email,
                                @RequestParam("motDePasse") String motDePasse,
                                @RequestParam("role") String role,
                                @RequestParam(value = "nom", required = false) String nom,
                                @RequestParam(value = "prenom", required = false) String prenom,
                                @RequestParam(value = "dateNaissance", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateNaissance,
                                @RequestParam(value = "idProfil", required = false) Integer idProfil,
                                Model model) {
        try {
            if (userRepository.findByEmail(email) != null) {
                model.addAttribute("error", "Cet email est déjà utilisé.");
                model.addAttribute("role", role);
                return "signin";
            }

            User user = new User();
            user.setEmail(email);
            user.setMotDePasse(motDePasse);
            user.setRole(User.Role.valueOf(role));

            if ("ADHERENT".equals(role)) {
                if (nom == null || nom.trim().isEmpty() || 
                    prenom == null || prenom.trim().isEmpty() || 
                    dateNaissance == null || 
                    idProfil == null) {
                    model.addAttribute("error", "Tous les champs sont requis pour les adhérents.");
                    model.addAttribute("role", role);
                    return "signin";
                }
                Adherent adherent = new Adherent();
                adherent.setNom(nom);
                adherent.setPrenom(prenom);
                adherent.setEmail(email);
                adherent.setDateNaissance(dateNaissance);
                adherent.setProfil(new Profil(idProfil));
                adherent.setStatut(Adherent.StatutAdherent.ACTIF);
                adherentRepository.save(adherent);
                user.setAdherent(adherent);
            }

            userRepository.save(user);
            return "redirect:/login?role=" + role;
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Une erreur est survenue lors de l'inscription. Veuillez vérifier vos informations.");
            model.addAttribute("role", role);
            return "signin";
        }
    }

   

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}

PretController :
package com.biblio.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.biblio.model.Pret;
import com.biblio.service.PretService;

@Controller
public class PretController {

    @Autowired
    private PretService pretService;

    @GetMapping("/admin/pret")
    public String showPretForm(Model model) {
        model.addAttribute("typesPret", new String[]{"DOMICILE", "SUR_PLACE"});
        return "pretForm";
    }

    @PostMapping("/admin/pret")
    public String preterExemplaire(@RequestParam("adherentId") Integer adherentId,
                                   @RequestParam("exemplaireId") Integer exemplaireId,
                                   @RequestParam("typePret") String typePret,
                                   Model model) {
        try {
            System.out.println("Début preterExemplaire: idAdherent=" + adherentId + ", idExemplaire=" + exemplaireId + ", typePret=" + typePret);
            Pret pret = pretService.preterExemplaire(adherentId, exemplaireId, typePret);
            model.addAttribute("message", "Prêt enregistré avec succès. ID du prêt: " + pret.getIdPret());
            return "pretForm";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "pretForm";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Une erreur inattendue est survenue lors de l'enregistrement du prêt.");
            return "pretForm";
        }
    }
}

ReservationController :
package com.biblio.controller;

import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.Reservation;
import com.biblio.model.User;
import com.biblio.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;

@Controller
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    @GetMapping("/adherent/reservation")
    public String showReservationPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.ADHERENT) {
            return "redirect:/login?role=ADHERENT";
        }
        List<Exemplaire> exemplaires = reservationService.findAllExemplairesWithLivres();
        model.addAttribute("exemplaires", exemplaires);
        model.addAttribute("typesPret", new String[]{"lecture_sur_place", "domicile"});
        return "reservationForm";
    }

    @PostMapping("/adherent/reservation")
    public String processReservation(@RequestParam("exemplaireId") int exemplaireId,
                                    @RequestParam("typePret") String typePret,
                                    @RequestParam("dateRetraitPrevue") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateRetraitPrevue,
                                    HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.ADHERENT) {
            return "redirect:/login?role=ADHERENT";
        }
        try {
            reservationService.reserverExemplaire(user.getAdherent().getIdAdherent(), exemplaireId, typePret, dateRetraitPrevue);
            model.addAttribute("message", "Réservation soumise avec succès. En attente de validation.");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        List<Exemplaire> exemplaires = reservationService.findAllExemplairesWithLivres();
        model.addAttribute("exemplaires", exemplaires);
        return "reservationForm";
    }

    @GetMapping("/admin/reservations")
    public String showPendingReservations(HttpSession session, Model model, @RequestParam(value = "message", required = false) String message,
                                          @RequestParam(value = "error", required = false) String error) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.BIBLIOTHECAIRE) {
            return "redirect:/login?role=BIBLIOTHECAIRE";
        }
        List<Reservation> pendingReservations = reservationService.findPendingReservations();
        model.addAttribute("reservations", pendingReservations);
        if (message != null) model.addAttribute("message", message);
        if (error != null) model.addAttribute("error", error);
        return "adminReservations";
    }

    @GetMapping("/admin/validatedReservations")
    public String showValidatedReservations(HttpSession session, Model model, @RequestParam(value = "message", required = false) String message,
                                            @RequestParam(value = "error", required = false) String error) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.BIBLIOTHECAIRE) {
            return "redirect:/login?role=BIBLIOTHECAIRE";
        }
        List<Reservation> validatedReservations = reservationService.findValidatedReservations();
        model.addAttribute("reservations", validatedReservations);
        if (message != null) model.addAttribute("message", message);
        if (error != null) model.addAttribute("error", error);
        return "validatedReservations";
    }

    @PostMapping("/admin/validateReservation")
    public String validateReservation(@RequestParam("idReservation") int idReservation, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.BIBLIOTHECAIRE) {
            return "redirect:/login?role=BIBLIOTHECAIRE";
        }
        try {
            reservationService.validerReservation(idReservation);
            return "redirect:/admin/reservations?message=Réservation validée avec succès";
        } catch (Exception e) {
            return "redirect:/admin/reservations?error=" + e.getMessage();
        }
    }

     @PostMapping("/admin/rejectReservation")
    public String rejectReservation(@RequestParam("idReservation") int idReservation, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.BIBLIOTHECAIRE) {
            return "redirect:/login?role=BIBLIOTHECAIRE";
        }
        try {
            reservationService.rejeterReservation(idReservation);
            return "redirect:/admin/reservations?message=Réservation rejetée avec succès";
        } catch (Exception e) {
            return "redirect:/admin/reservations?error=" + e.getMessage();
        }
    }


    @PostMapping("/admin/convertToPret")
    public String convertToPret(@RequestParam("idReservation") int idReservation,
                               @RequestParam("idAdherent") int idAdherent,
                               HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.BIBLIOTHECAIRE) {
            return "redirect:/login?role=BIBLIOTHECAIRE";
        }
        try {
            reservationService.convertToPret(idReservation, idAdherent);
            return "redirect:/admin/validatedReservations?message=Réservation convertie en prêt avec succès";
        } catch (Exception e) {
            return "redirect:/admin/validatedReservations?error=" + e.getMessage();
        }
    }
}

RetourController :
package com.biblio.controller;





import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.biblio.exception.PretException;
import com.biblio.service.RetourService;

@Controller
public class RetourController {

    @Autowired
    private RetourService retourService;

    @GetMapping("/admin/retour")
    public String showRetourForm() {
   
   
        return "retourForm";
    }



    @PostMapping("/admin/retour")
    public String retournerExemplaire(@RequestParam("idPret") Integer idPret, Model model) {
        try {
            retourService.retournerExemplaire(idPret);
            model.addAttribute("message", "Prêt retourné avec succès. ID du prêt: " + idPret);
            return "retourForm";
        } catch (PretException e) {
            model.addAttribute("error", e.getMessage());
            return "retourForm";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Une erreur inattendue est survenue lors du retour du prêt.");
            return "retourForm";
        }
    }
}

dans exception :
 PretException :
package com.biblio.exception;

public class PretException extends RuntimeException {
    public PretException(String message) {
        super(message);
    }
}

dans model :
Abonnement :
je vous le fourni pas car le prompt va etre trop long


Adherent :
je vous le fourni pas car le prompt va etre trop long


Exemplaire :
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

JourFerie :
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
public class JourFerie {

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
    public JourFerie() {}

    public JourFerie(LocalDate dateFerie, String description, RegleRendu regleRendu) {
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

Livre :
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

Pret :
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

Profil :
package com.biblio.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "Profil")
public class Profil {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_profil")
    private int idProfil;

    @Enumerated(EnumType.STRING)
    @Column(name = "type_profil", nullable = false)
    private TypeProfil typeProfil;

    @Column(name = "duree_pret", nullable = false)
    private int dureePret;

    @Column(name = "quota_pret", nullable = false)
    private int quotaPret;

    @Column(name = "quota_prolongement", nullable = false)
    private int quotaProlongement;

    @Column(name = "quota_reservation", nullable = false)
    private int quotaReservation;

    @Column(name = "duree_penalite", nullable = false)
    private int dureePenalite;

    public enum TypeProfil {
        ETUDIANT, PROFESSEUR, PROFESSIONNEL
    }

    // Constructeurs
    public Profil() {}

     public Profil(Integer idProfil) {
        this.idProfil = idProfil;
    }

    public Profil(int idProfil, TypeProfil typeProfil, int dureePret, int quotaPret, int quotaProlongement, int quotaReservation, int dureePenalite) {
        this.idProfil = idProfil;
        this.typeProfil = typeProfil;
        this.dureePret = dureePret;
        this.quotaPret = quotaPret;
        this.quotaProlongement = quotaProlongement;
        this.quotaReservation = quotaReservation;
        this.dureePenalite = dureePenalite;
    }

    // Getters et Setters
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

Reservation :
package com.biblio.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

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

    @Column(name = "date_reservation", nullable = false)
    private LocalDateTime dateReservation;

    @Column(name = "date_retrait_prevue", nullable = false)
    private LocalDate dateRetraitPrevue;

    @Column(name = "date_expiration", nullable = false)
    private LocalDateTime dateExpiration;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut", nullable = false)
    private Statut statut;

   public enum Statut {
        EN_ATTENTE, VALIDEE, ANNULEE, EXPIREE, CONVERTIE_EN_PRET
    }

    // Constructeurs
    public Reservation() {}

    public Reservation(Exemplaire exemplaire, Adherent adherent, LocalDateTime dateReservation, LocalDate dateRetraitPrevue, LocalDateTime dateExpiration) {
        this.exemplaire = exemplaire;
        this.adherent = adherent;
        this.dateReservation = dateReservation;
        this.dateRetraitPrevue = dateRetraitPrevue;
        this.dateExpiration = dateExpiration;
        this.statut = Statut.EN_ATTENTE;
    }

    // Getters et Setters
    public int getIdReservation() { return idReservation; }
    public void setIdReservation(int idReservation) { this.idReservation = idReservation; }
    public Exemplaire getExemplaire() { return exemplaire; }
    public void setExemplaire(Exemplaire exemplaire) { this.exemplaire = exemplaire; }
    public Adherent getAdherent() { return adherent; }
    public void setAdherent(Adherent adherent) { this.adherent = adherent; }
    public LocalDateTime getDateReservation() { return dateReservation; }
    public void setDateReservation(LocalDateTime dateReservation) { this.dateReservation = dateReservation; }
    public LocalDate getDateRetraitPrevue() { return dateRetraitPrevue; }
    public void setDateRetraitPrevue(LocalDate dateRetraitPrevue) { this.dateRetraitPrevue = dateRetraitPrevue; }
    public LocalDateTime getDateExpiration() { return dateExpiration; }
    public void setDateExpiration(LocalDateTime dateExpiration) { this.dateExpiration = dateExpiration; }
    public Statut getStatut() { return statut; }
    public void setStatut(Statut statut) { this.statut = statut; }

    public enum TypePret {
        DOMICILE, SUR_PLACE
    }

    public com.biblio.model.Pret.TypePret getTypePret() {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getTypePret'");
    }
}

User :
je vous le fourni pas car le prompt va etre trop long


dans repository :
AbonnementRepository :
je vous le fourni pas car le prompt va etre trop long


AdherentRepository :
je vous le fourni pas car le prompt va etre trop long

ExemplaireRepository :
package com.biblio.repository;

import com.biblio.model.Exemplaire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ExemplaireRepository extends JpaRepository<Exemplaire, Integer> {
    @Query("SELECT e FROM Exemplaire e JOIN FETCH e.livre")
    List<Exemplaire> findAllWithLivre();
}

JourFerieRepository :
je vous le fourni pas car le prompt va etre trop long

LivreRepository :
package com.biblio.repository;

import com.biblio.model.Livre;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LivreRepository extends JpaRepository<Livre, Integer> {
}

PretRepository :
package com.biblio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.biblio.model.Pret;

public interface PretRepository extends JpaRepository<Pret, Integer> {
    @Query("SELECT COUNT(p) FROM Pret p WHERE p.adherent.idAdherent = :idAdherent AND p.dateRetourEffective IS NULL")
    long countActivePretsByAdherent(@Param("idAdherent") int idAdherent);
}


ReservationRepository :
package com.biblio.repository;

import com.biblio.model.Adherent;
import com.biblio.model.Reservation;
import com.biblio.model.Reservation.Statut;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ReservationRepository extends JpaRepository<Reservation, Integer> {
    @Query("SELECT COUNT(r) FROM Reservation r WHERE r.adherent = :adherent AND r.statut NOT IN :statuts")
    long countByAdherentAndStatutNotIn(@Param("adherent") Adherent adherent, @Param("statuts") List<Statut> statuts);

    @Query("SELECT r FROM Reservation r WHERE r.statut = :statut")
    List<Reservation> findByStatut(@Param("statut") Statut statut);
}

UserRepository :
je vous le fourni pas car le prompt va etre trop long


dans service :
AbonnementService :
je vous le fourni pas car le prompt va etre trop long

PretService :
package com.biblio.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.DayOfWeek;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.biblio.exception.PretException;
import com.biblio.model.Abonnement;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.JourFerie;
import com.biblio.model.Pret;
import com.biblio.model.Profil;
import com.biblio.repository.AbonnementRepository;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.JourFerieRepository;
import com.biblio.repository.PretRepository;

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
    public Pret preterExemplaire(int idAdherent, int idExemplaire, String typePret) {
        System.out.println("Début preterExemplaire: idAdherent=" + idAdherent + ", idExemplaire=" + idExemplaire + ", typePret=" + typePret);

        // Valider l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));
        System.out.println("Adhérent trouvé: " + adherent.getIdAdherent() + ", Statut: " + adherent.getStatut());

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
        System.out.println("Abonnement trouvé: " + abonnement.getIdAbonnement());

        // Vérifier l'exemplaire
        Exemplaire exemplaire = exemplaireRepository.findById(idExemplaire)
                .orElseThrow(() -> new PretException("L'exemplaire n'existe pas."));
        System.out.println("Exemplaire trouvé: " + exemplaire.getIdExemplaire() + ", Statut: " + exemplaire.getStatut());
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
        System.out.println("Nombre de prêts actifs: " + activePrets + ", Quota: " + adherent.getProfil().getQuotaPret()+ ", Quota restant: " + adherent.getQuotaRestant());
        if (activePrets >= adherent.getProfil().getQuotaPret() || adherent.getQuotaRestant() <= 0) {
            throw new PretException("L'adhérent a atteint son quota de prêts.");
        }
        adherent.setQuotaRestant(adherent.getQuotaRestant() - 1);
        adherentRepository.save(adherent);  

        // Calculer la date de retour prévue
        LocalDateTime datePret = LocalDateTime.now();
        LocalDateTime dateRetourPrevue = datePret.plusDays(adherent.getProfil().getDureePret());
        System.out.println("Date prêt: " + datePret + ", Date retour prévue: " + dateRetourPrevue);

        // Vérifier les jours fériés
        List<JourFerie> joursFeries = jourFerieRepository.findByDateFerieBetween(
                datePret.toLocalDate(), dateRetourPrevue.toLocalDate());
        for (JourFerie jour : joursFeries) {
            System.out.println("Jour férié trouvé: " + jour.getDateFerie());
            if (jour.getRegleRendu() == JourFerie.RegleRendu.AVANT
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.minusDays(1);
            } else if (jour.getRegleRendu() == JourFerie.RegleRendu.APRES
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.plusDays(1);
            }
        }

        while (dateRetourPrevue.getDayOfWeek() == DayOfWeek.SATURDAY || 
               dateRetourPrevue.getDayOfWeek() == DayOfWeek.SUNDAY) {
            System.out.println("Date retour prévue tombe un week-end: " + dateRetourPrevue);
            dateRetourPrevue = dateRetourPrevue.minusDays(1); // Avancer au vendredi précédent
        }

        //si je veux que ça soit repousser au lundi (apres au lieu d'avant)
        /* while (dateRetourPrevue.getDayOfWeek() == DayOfWeek.SATURDAY || 
            dateRetourPrevue.getDayOfWeek() == DayOfWeek.SUNDAY) {
            System.out.println("Date retour prévue tombe un week-end: " + dateRetourPrevue);
            dateRetourPrevue = dateRetourPrevue.plusDays(1); // Repousser au lundi suivant
        } */

        joursFeries = jourFerieRepository.findByDateFerieBetween(
                datePret.toLocalDate(), dateRetourPrevue.toLocalDate());
        for (JourFerie jour : joursFeries) {
            System.out.println("Jour férié trouvé après ajustement: " + jour.getDateFerie());
            if (jour.getRegleRendu() == JourFerie.RegleRendu.AVANT
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.minusDays(1);
            } else if (jour.getRegleRendu() == JourFerie.RegleRendu.APRES
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.plusDays(1);
            }
        }

        System.out.println("Date retour prévue ajustée: " + dateRetourPrevue);

        // Créer le prêt
        Pret pret = new Pret();
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        try {
            pret.setTypePret(Pret.TypePret.valueOf(typePret.replace(" ", "_").toUpperCase()));
        } catch (IllegalArgumentException e) {
            System.out.println("Erreur typePret: " + typePret);
            throw new PretException("Type de prêt invalide: " + typePret);
        }
        pret.setDatePret(datePret);
        pret.setDateRetourPrevue(dateRetourPrevue);

        // Mettre à jour le statut de l'exemplaire
        exemplaire.setStatut(Pret.TypePret.valueOf(typePret.replace(" ", "_").toUpperCase()) == Pret.TypePret.DOMICILE
                ? Exemplaire.StatutExemplaire.EN_PRET
                : Exemplaire.StatutExemplaire.LECTURE_SUR_PLACE);
        System.out.println("Nouveau statut exemplaire: " + exemplaire.getStatut());

        // Enregistrer les changements
        try {
            exemplaireRepository.save(exemplaire);
            System.out.println("Exemplaire enregistré: " + exemplaire.getIdExemplaire());
            pretRepository.save(pret);
            System.out.println("Prêt enregistré: " + pret.getIdPret());
            return pret; // Retourner l'objet Pret
        } catch (Exception e) {
            e.printStackTrace();
            throw new PretException("Erreur lors de l'enregistrement du prêt: " + e.getMessage());
        }
    }

   
}

ReservationService :
package com.biblio.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.biblio.exception.PretException;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.Livre;
import com.biblio.model.Pret;
import com.biblio.model.Profil;
import com.biblio.model.Reservation;
import com.biblio.model.Reservation.Statut;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.LivreRepository;
import com.biblio.repository.PretRepository;
import com.biblio.repository.ReservationRepository;
import com.biblio.service.PretService;

@Service
public class ReservationService {

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private LivreRepository livreRepository;

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private PretService pretService;

    public List<Exemplaire> findAllExemplairesWithLivres() {
        return exemplaireRepository.findAllWithLivre();
    }

    @Transactional
    public Reservation reserverExemplaire(int idAdherent, int idExemplaire, String typePret, LocalDate dateRetraitPrevue) {
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));
        if (adherent.getStatut() == Adherent.StatutAdherent.SANCTIONNE) {
            throw new PretException("L'adhérent est sous sanction.");
        }
        if (!hasActiveSubscription(adherent)) {
            throw new PretException("Aucune cotisation active trouvée.");
        }
        Exemplaire exemplaire = exemplaireRepository.findById(idExemplaire)
                .orElseThrow(() -> new PretException("L'exemplaire n'existe pas."));
        if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
            throw new PretException("L'exemplaire n'est pas disponible pour la date sélectionnée.");
        }
        int age = LocalDate.now().getYear() - adherent.getDateNaissance().getYear();
        if (exemplaire.getLivre().getRestrictionAge() > age) {
            throw new PretException("L'adhérent ne satisfait pas à la restriction d'âge.");
        }
        if (exemplaire.getLivre().isProfesseurSeulement() && adherent.getProfil().getTypeProfil() != Profil.TypeProfil.PROFESSEUR) {
            throw new PretException("Livre réservé aux professeurs.");
        }
        long activeReservations = reservationRepository.countByAdherentAndStatutNotIn(adherent, List.of(Statut.ANNULEE, Statut.EXPIREE));
        if (activeReservations >= adherent.getProfil().getQuotaReservation()) {
            throw new PretException("Quota de réservations dépassé.");
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime dateExpiration = now.plusDays(7);
        Reservation reservation = new Reservation(exemplaire, adherent, now, dateRetraitPrevue, dateExpiration);
        adherent.setQuotaRestant(adherent.getQuotaRestant() - 1);
        adherentRepository.save(adherent);
        return reservationRepository.save(reservation);
    }

    public List<Reservation> findPendingReservations() {
        return reservationRepository.findByStatut(Statut.EN_ATTENTE);
    }

    @Transactional
    public void validerReservation(int idReservation) {
        Reservation reservation = reservationRepository.findById(idReservation)
                .orElseThrow(() -> new PretException("La réservation n'existe pas."));
        if (reservation.getStatut() != Statut.EN_ATTENTE) {
            throw new PretException("La réservation ne peut pas être validée.");
        }
        reservation.setStatut(Statut.VALIDEE);
        reservation.getExemplaire().setStatut(Exemplaire.StatutExemplaire.RESERVE);
        reservationRepository.save(reservation);
        exemplaireRepository.save(reservation.getExemplaire());
    }

    @Transactional
    public void rejeterReservation(int idReservation) {
        Reservation reservation = reservationRepository.findById(idReservation)
                .orElseThrow(() -> new PretException("La réservation n'existe pas."));
        if (reservation.getStatut() != Statut.EN_ATTENTE) {
            throw new PretException("La réservation ne peut pas être rejetée.");
        }
        reservation.setStatut(Statut.ANNULEE);
        reservation.getAdherent().setQuotaRestant(reservation.getAdherent().getQuotaRestant() + 1);
        reservationRepository.save(reservation);
        adherentRepository.save(reservation.getAdherent());
    }
 
    @Transactional
    public void convertToPret(int idReservation, int idAdherent) {
        Reservation reservation = reservationRepository.findById(idReservation)
                .orElseThrow(() -> new PretException("La réservation n'existe pas."));
        if (reservation.getStatut() != Statut.VALIDEE) {
            throw new PretException("La réservation doit être validée pour être convertie en prêt.");
        }
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));
        Exemplaire exemplaire = reservation.getExemplaire();

        // Créer un nouveau prêt
        Pret pret = new Pret();
        pret.setExemplaire(exemplaire);
        pret.setAdherent(adherent);
        pret.setTypePret(reservation.getTypePret()); // À ajuster si typePret est stocké dans Reservation
        pret.setDatePret(LocalDateTime.now());
        pret.setDateRetourPrevue(reservation.getDateRetraitPrevue().atStartOfDay().plusDays(adherent.getProfil().getDureePret()));
        pretRepository.save(pret);

        // Mettre à jour l'exemplaire et la réservation
        exemplaire.setStatut(Exemplaire.StatutExemplaire.EN_PRET);
        reservation.setStatut(Statut.ANNULEE); // La réservation est terminée une fois convertie
        exemplaireRepository.save(exemplaire);
        reservationRepository.save(reservation);
    }

    @Transactional
    public void annulerReservationExpiree(Reservation reservation) {
        if (reservation.getStatut() == Statut.EN_ATTENTE && LocalDateTime.now().isAfter(reservation.getDateExpiration())) {
            reservation.setStatut(Statut.EXPIREE);
            reservation.getAdherent().setQuotaRestant(reservation.getAdherent().getQuotaRestant() + 1);
            reservation.getExemplaire().setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);
            reservationRepository.save(reservation);
            adherentRepository.save(reservation.getAdherent());
            exemplaireRepository.save(reservation.getExemplaire());
        }
    }

    private boolean hasActiveSubscription(Adherent adherent) {
        return true; // À remplacer par une vraie vérification avec AbonnementRepository
    }

    public List<Reservation> findValidatedReservations() {
        return reservationRepository.findByStatut(Statut.VALIDEE);
    }
}

RetourService :
package com.biblio.service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.biblio.exception.PretException;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.Pret;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.PretRepository;

@Service
public class RetourService {

    @Autowired
    private PretRepository pretRepository;

    
    @Autowired
    private ExemplaireRepository exemplaireRepository;

     @Autowired
    private AdherentRepository adherentRepository;



    @Transactional
    public void retournerExemplaire(int idPret) {
        System.out.println("Début retournerExemplaire: idPret=" + idPret);

        // Trouver le prêt
        Pret pret = pretRepository.findById(idPret)
                .orElseThrow(() -> new PretException("Le prêt n'existe pas."));
        if (pret.getDateRetourEffective() != null) {
            throw new PretException("Le prêt a déjà été retourné.");
        }

        // Mettre à jour la date de retour effective
        pret.setDateRetourEffective(LocalDateTime.now());

        // Mettre à jour le statut de l'exemplaire
        Exemplaire exemplaire = pret.getExemplaire();
        exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);

        // Incrémenter le quota restant de l'adhérent
        Adherent adherent = pret.getAdherent();
        adherent.setQuotaRestant(adherent.getQuotaRestant() + 1);

        // Enregistrer les changements
        try {
            pretRepository.save(pret);
            exemplaireRepository.save(exemplaire);
            adherentRepository.save(adherent);
            System.out.println("Prêt retourné: " + pret.getIdPret() + ", Exemplaire: " + exemplaire.getIdExemplaire() + ", Quota restant: " + adherent.getQuotaRestant());
        } catch (Exception e) {
            e.printStackTrace();
            throw new PretException("Erreur lors du retour du prêt: " + e.getMessage());
        }
    }
    
}


Application :
je vous le fourni pas car le prompt va etre trop long

webapp/css :
adherent.css :
body {
    background: url('https://images.unsplash.com/photo-1512820790803-83ca1980f6b9') no-repeat center center fixed;
    background-size: cover;
    min-height: 100vh;
    margin: 0;
    font-family: 'Georgia', serif;
}
.sidebar {
    position: fixed;
    top: 0;
    left: 0;
    height: 100%;
    width: 250px;
    background-color: rgba(139, 69, 19, 0.95);
    padding-top: 20px;
    color: white;
}
.sidebar a {
    color: white;
    padding: 15px;
    display: block;
    text-decoration: none;
    transition: background-color 0.3s;
}
.sidebar a:hover {
    background-color: #A0522D;
}
.content {
    margin-left: 270px;
    padding: 20px;
}
.card {
    background-color: rgba(255, 255, 255, 0.95);
    border: 1px solid #8B4513;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    transition: transform 0.3s;
    text-align: center !important;
}
.card:hover {
    transform: scale(1.05);
}
.card-title {
    color: #8B4513;
    font-weight: bold;
}
.card-text {
    color: #333;
}
.btn-custom {
    background-color: #8B4513;
    color: white;
    border: none;
}
.btn-custom:hover {
    background-color: #A0522D;
}

admin.css :
body {
    background: url('https://images.unsplash.com/photo-1512820790803-83ca1980f6b9') no-repeat center center fixed;
    background-size: cover;
    min-height: 100vh;
    margin: 0;
    font-family: 'Georgia', serif;
}
.sidebar {
    position: fixed;
    top: 0;
    left: 0;
    height: 100%;
    width: 250px;
    background-color: rgba(139, 69, 19, 0.95);
    padding-top: 20px;
    color: white;
}
.sidebar a {
    color: white;
    padding: 15px;
    display: block;
    text-decoration: none;
    transition: background-color 0.3s;
}
.sidebar a:hover {
    background-color: #A0522D;
}
.content {
    margin-left: 270px;
    padding: 20px;
}
.card {
    background-color: rgba(255, 255, 255, 0.95);
    border: 1px solid #8B4513;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    transition: transform 0.3s;
    text-align: center !important;
}
.card:hover {
    transform: scale(1.05);
}
.card-title {
    color: #8B4513;
    font-weight: bold;
}
.card-text {
    color: #333;
}
.btn-custom {
    background-color: #8B4513;
    color: white;
    border: none;
}
.btn-custom:hover {
    background-color: #A0522D;
}
.form-container {
    background-color: rgba(255, 255, 255, 0.95);
    padding: 2rem;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    max-width: 500px;
    margin: auto;
}
.error {
    color: red;
    font-size: 0.9em;
    margin-top: 10px;
}
.success {
    color: green;
    font-size: 0.9em;
    margin-top: 10px;
}
h2 {
    color: #8B4513;
    font-weight: bold;
    text-align: center;
}

public.css :
body {
    background: url('https://images.unsplash.com/photo-1512820790803-83ca1980f6b9') no-repeat center center fixed;
    background-size: cover;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 0;
    font-family: 'Georgia', serif;
}
.card {
    background-color: rgba(255, 255, 255, 0.95);
    border: 1px solid #8B4513;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    transition: transform 0.3s;
}
.card:hover {
    transform: scale(1.05);
}
.card-title {
    color: #8B4513;
    font-weight: bold;
}
.card-text {
    color: #333;
}
.btn-custom {
    background-color: #8B4513;
    color: white;
    border: none;
}
.btn-custom:hover {
    background-color: #A0522D;
}
.login-container, .signin-container {
    background-color: rgba(255, 255, 255, 0.95);
    padding: 2rem;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    width: 100%;
    max-width: 400px;
}
.error {
    color: red;
    font-size: 0.9em;
}

WEB-INF/views/fragments 
sidebar-admin.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
    <h3 class="text-center mb-4">Menu Bibliothécaire</h3>
    <a href="/admin/pret">Gérer les Prêts</a>
    <a href="/admin/retour">Retour des Prêts</a>
    <a href="/admin/reservations">Gérer les Réservations</a>
    <a href="/admin/livre">Gérer les Livres</a>
    <a href="/admin/exemplaire">Gérer les Exemplaires</a>
    <a href="/admin/adherent">Gérer les Adhérents</a>
    <a href="/logout" class="btn btn-custom mt-3 ms-3">Déconnexion</a>
</div>

sidebar-adherent.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
    <h3 class="text-center mb-4">Menu Adhérent</h3>
    <a href="/adherent/prets">Voir mes Prêts</a>
    <a href="/adherent/reservations">Voir mes Réservations</a>
    <a href="/adherent/profil">Mon Profil</a>
    <a href="/adherent/reservation">Réserver un Livre</a>
    <a href="/logout" class="btn btn-custom mt-3 ms-3">Déconnexion</a>
</div>

adherentDashaboard :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tableau de Bord - Adhérent</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/adherent.css" rel="stylesheet">
</head>
<body>
    <%@ include file="fragments/sidebar-adherent.jsp" %>
    <div class="content">
        <div class="container">
            <h1 class="text-center mb-4" style="color: white; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);">Tableau de Bord Adhérent</h1>
            <div class="row">
                <div class="col-md-6 mx-auto">
                    <div class="card p-4 mb-4 text-center">
                        <h3 class="card-title">Bienvenue, Adhérent</h3>
                        <p class="card-text">Utilisez le menu à gauche pour consulter vos prêts, réservations ou votre profil.</p>
                    </div>
                </div>
            </div>
            ${content}
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

adminDashboard.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tableau de Bord - Bibliothécaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/admin.css" rel="stylesheet">
</head>
<body>
    <%@ include file="fragments/sidebar-admin.jsp" %>
    <div class="content">
        <div class="container">
            <h1 class="text-center mb-4" style="color: white; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);">Tableau de Bord Bibliothécaire</h1>
           <div class="row">
                <div class="col-md-6 mx-auto">
                    <div class="card p-4 mb-4">
                        <div class="text-center">
                            <h3 class="card-title">Bienvenue, Bibliothécaire</h3>
                            <p class="card-text">Utilisez le menu à gauche pour gérer les prêts, réservations, livres, exemplaires et adhérents.</p>
                        </div>
                    </div>
                </div>
            </div>
            ${content}
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

choice.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bibliothèque - Choix du Profil</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/public.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h1 class="text-center mb-5" style="color: white; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);">Bienvenue à la Bibliothèque</h1>
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card text-center p-4 m-2">
                    <h3 class="card-title">Accéder en tant qu'Adhérent</h3>
                    <p class="card-text">Connectez-vous pour consulter vos prêts, etc.</p>
                    <a href="/login?role=ADHERENT" class="btn btn-custom">Connexion Adhérent</a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center p-4 m-2">
                    <h3 class="card-title">Accéder en tant que Bibliothécaire</h3>
                    <p class="card-text">Gérez les prêts, réservations et le catalogue.</p>
                    <a href="/login?role=BIBLIOTHECAIRE" class="btn btn-custom">Connexion Bibliothécaire</a>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

login.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bibliothèque - Connexion</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/public.css" rel="stylesheet">
</head>
<body>
    <div class="login-container">
        <h2 class="text-center mb-4" style="color: #8B4513;">Connexion <%= request.getParameter("role") %></h2>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
        <form action="/login" method="post">
            <input type="hidden" name="role" value="<%= request.getParameter("role") %>">
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="mb-3">
                <label for="motDePasse" class="form-label">Mot de passe</label>
                <input type="password" class="form-control" id="motDePasse" name="motDePasse" required>
            </div>
            <button type="submit" class="btn btn-custom w-100">Se connecter</button>
        </form>
        <p class="text-center mt-3">Pas de compte ? <a href="/signin?role=<%= request.getParameter("role") %>">S'inscrire</a></p>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

pretForm.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Formulaire de Prêt</h2>
        <form action="/admin/pret" method="post">
            <div class="mb-3">
                <label for="idAdherent" class="form-label">ID Adhérent</label>
                <input type="number" class="form-control" id="idAdherent" name="adherentId" required>
            </div>
            <div class="mb-3">
                <label for="idExemplaire" class="form-label">ID Exemplaire</label>
                <input type="number" class="form-control" id="idExemplaire" name="exemplaireId" required>
            </div>
            <div class="mb-3">
                <label for="typePret" class="form-label">Type de prêt</label>
                <select class="form-control" id="typePret" name="typePret" required>
                    <option value="SUR_PLACE">Sur place</option>
                    <option value="DOMICILE">Domicile</option>
                </select>
            </div>
            <button type="submit" class="btn btn-custom w-100">Valider le prêt</button>
            <c:if test="${not empty message}">
                <p class="success">${message}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>
        </form>
        <a href="/admin/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>

reservationForm.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/adherent.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Réserver un Exemplaire</h2>
        <div class="mb-3">
            <input type="text" class="form-control" id="searchBar" placeholder="Rechercher un exemplaire..." onkeyup="filterExemplaires()">
        </div>
        <div class="row" id="exemplaireCards">
            <c:forEach var="exemplaire" items="${exemplaires}">
                <c:if test="${exemplaire.statut == 'DISPONIBLE'}">
                    <div class="col-md-4 mb-3">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Exemplaire ID: ${exemplaire.idExemplaire}</h5>
                                <p class="card-text">Titre: ${exemplaire.livre.titre}</p>
                                <p class="card-text">Auteur: ${exemplaire.livre.auteur}</p>
                                <p class="card-text">ISBN: ${exemplaire.livre.isbn}</p>
                                <p class="card-text">Âge min: ${exemplaire.livre.restrictionAge}</p>
                                <p class="card-text">Professeurs seulement: ${exemplaire.livre.professeurSeulement ? 'Oui' : 'Non'}</p>
                                <button class="btn btn-custom select-btn" data-id="${exemplaire.idExemplaire}">Sélectionner</button>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
        <form id="reservationForm" action="/adherent/reservation" method="post" class="mt-4">
            <input type="hidden" id="exemplaireId" name="exemplaireId" value="">
            <div class="mb-3">
                <label for="typePret" class="form-label">Type de prêt</label>
                <select class="form-control" id="typePret" name="typePret" required>
                    <option value="lecture_sur_place">Lecture sur place</option>
                    <option value="domicile">Domicile</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="dateRetraitPrevue" class="form-label">Date de retrait prévue</label>
                <input type="date" class="form-control" id="dateRetraitPrevue" name="dateRetraitPrevue" required>
            </div>
            <button type="submit" class="btn btn-custom w-100">Soumettre la réservation</button>
            <c:if test="${not empty message}">
                <p class="success">${message}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>
        </form>
        <a href="/adherent/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
    <script>
        document.querySelectorAll('.select-btn').forEach(button => {
            button.addEventListener('click', function() {
                document.getElementById('exemplaireId').value = this.getAttribute('data-id');
                document.querySelectorAll('.select-btn').forEach(btn => btn.classList.remove('selected'));
                this.classList.add('selected');
            });
        });

        function filterExemplaires() {
            let input = document.getElementById("searchBar").value.toLowerCase();
            let cards = document.getElementById("exemplaireCards").getElementsByClassName("card");
            for (let i = 0; i < cards.length; i++) {
                let title = cards[i].getElementsByTagName("h5")[0].innerText.toLowerCase();
                let text = cards[i].innerText.toLowerCase();
                if (text.includes(input)) {
                    cards[i].parentElement.style.display = "";
                } else {
                    cards[i].parentElement.style.display = "none";
                }
            }
        }
    </script>
    <style>
        .selected {
            background-color: #28a745;
            color: white;
        }
    </style>
</c:set>
<%@ include file="adherentDashboard.jsp" %>

retourForm.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Retourner un Prêt</h2>
        <form action="/admin/retour" method="post">
            <div class="mb-3">
                <label for="idPret" class="form-label">ID du Prêt</label>
                <input type="number" class="form-control" id="idPret" name="idPret" required>
            </div>
            <button type="submit" class="btn btn-custom w-100">Retourner le prêt</button>
            <c:if test="${not empty message}">
                <p class="success">${message}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>
        </form>
        <a href="/admin/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>

signin.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bibliothèque - Inscription</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/public.css" rel="stylesheet">
</head>
<body>
    <div class="signin-container">
        <h2 class="text-center mb-4" style="color: #8B4513;">Inscription <%= request.getParameter("role") %></h2>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
        <form action="/signin" method="post">
            <input type="hidden" name="role" value="<%= request.getParameter("role") %>">
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="mb-3">
                <label for="motDePasse" class="form-label">Mot de passe</label>
                <input type="password" class="form-control" id="motDePasse" name="motDePasse" required>
            </div>
            <% if ("ADHERENT".equals(request.getParameter("role"))) { %>
                <div class="mb-3">
                    <label for="nom" class="form-label">Nom</label>
                    <input type="text" class="form-control" id="nom" name="nom" required>
                </div>
                <div class="mb-3">
                    <label for="prenom" class="form-label">Prénom</label>
                    <input type="text" class="form-control" id="prenom" name="prenom" required>
                </div>
                <div class="mb-3">
                    <label for="dateNaissance" class="form-label">Date de naissance</label>
                    <input type="date" class="form-control" id="dateNaissance" name="dateNaissance" required>
                </div>
                <div class="mb-3">
                    <label for="idProfil" class="form-label">Type de profil</label>
                    <select class="form-control" id="idProfil" name="idProfil" required>
                        <option value="1">ETUDIANT</option>
                        <option value="2">PROFESSIONNEL</option>
                        <option value="3">PROFESSEUR</option>
                    </select>
                </div>
            <% } %>
            <button type="submit" class="btn btn-custom w-100">S'inscrire</button>
        </form>
        <p class="text-center mt-3">Déjà un compte ? <a href="/login?role=<%= request.getParameter("role") %>">Se connecter</a></p>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

validatedReservations.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Réservations validées</h2>
        <c:if test="${not empty message}">
            <p class="success">${message}</p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <table class="table">
            <thead>
                <tr>
                    <th>ID Réservation</th>
                    <th>Adhérent</th>
                    <th>Exemplaire</th>
                    <th>Date Retrait</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="reservation" items="${reservations}">
                    <tr>
                        <td>${reservation.idReservation}</td>
                        <td>${reservation.adherent.nom} ${reservation.adherent.prenom}</td>
                        <td>${reservation.exemplaire.livre.titre}</td>
                        <td>${reservation.dateRetraitPrevue}</td>
                        <td>
                            <form action="/admin/convertToPret" method="post" style="display:inline;">
                                <input type="hidden" name="idReservation" value="${reservation.idReservation}">
                                <input type="hidden" name="idAdherent" value="${reservation.adherent.idAdherent}">
                                <button type="submit" class="btn btn-custom btn-sm" style="background-color: #8B4513;">Convertir en Prêt</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <a href="/admin/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>

pom.xml :
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.biblio</groupId>
    <artifactId>bibli</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>jar</packaging> <!-- Changé de war à jar pour Spring Boot -->
    <name>gestion-bibliotheque</name>

    <properties>
        <java.version>17</java.version>
        <spring-boot.version>2.7.18</spring-boot.version>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    </properties>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.18</version>
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
            <!-- <version>1.2</version> -->
        </dependency>
        <!-- Tomcat embarqué pour supporter JSP -->
        <!-- <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
            <scope>provided</scope>
        </dependency> -->
        <!-- Tomcat Jasper pour le rendu des JSP -->
        <!-- <dependency>
            <groupId>org.apache.tomcat</groupId>
            <artifactId>tomcat-jasper</artifactId>
            <version>9.0.50</version>
        </dependency> -->
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
            <version>5.14.0</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-junit-jupiter</artifactId>
            <version>5.14.0</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.tomcat.embed</groupId>
            <artifactId>tomcat-embed-jasper</artifactId>
        </dependency>
        <dependency>
            <groupId>net.bytebuddy</groupId>
            <artifactId>byte-buddy</artifactId>
            <version>1.15.7</version> <!-- Version compatible avec Java 17 -->
            <!-- <scope>test</scope> -->
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <!-- Plugin Spring Boot -->
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <version>2.7.18</version>
                <!-- <version>${spring-boot.version}</version> -->
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
                    <source>17</source>
                    <target>17</target>
                    <encoding>UTF-8</encoding>
                </configuration>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.2.5</version>
                <configuration>
                    <argLine>-Dnet.bytebuddy.experimental=true</argLine> <!-- Pour supporter les mocks inline -->
                </configuration>
                <dependencies>
                    <dependency>
                        <groupId>org.junit.jupiter</groupId>
                        <artifactId>junit-jupiter-engine</artifactId>
                        <version>5.10.2</version>
                    </dependency>
                </dependencies>
            </plugin>
        </plugins>
    </build>
</project>


PretServiceTest.java :
je vous le fourni pas car le prompt va etre trop long

base :
drop database if exists gestion_bibliotheque;
CREATE DATABASE if not exists gestion_bibliotheque;
USE gestion_bibliotheque;

CREATE TABLE Profil (
    id_profil INT PRIMARY KEY AUTO_INCREMENT,
    type_profil ENUM('ETUDIANT', 'PROFESSEUR', 'PROFESSIONNEL') NOT NULL,
    duree_pret INT NOT NULL,  
    quota_pret INT NOT NULL,       
    quota_prolongement INT NOT NULL,        
    quota_reservation INT NOT NULL,          
    duree_penalite INT NOT NULL              
);



CREATE TABLE Adherent (
    id_adherent INT PRIMARY KEY AUTO_INCREMENT,
    id_profil INT NOT NULL,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telephone VARCHAR(20),
    statut ENUM('ACTIF', 'INACTIF', 'SANCTIONNE') DEFAULT 'ACTIF',
    date_naissance DATE NOT NULL, 
    quotat_restant int default null, -- Pour vérifier les restrictions d'âge
    FOREIGN KEY (id_profil) REFERENCES Profil(id_profil) ON DELETE RESTRICT
);

CREATE TABLE Abonnement (
    id_abonnement INT PRIMARY KEY AUTO_INCREMENT,
    id_adherent INT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    montant DECIMAL(10,2) NOT NULL,  -- Ajout du montant
    statut ENUM('ACTIVE', 'EXPIREE') DEFAULT 'ACTIVE',
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE
);

CREATE TABLE Livre (
    id_livre INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(255) NOT NULL,
    auteur VARCHAR(255),
    editeur VARCHAR(255),
    annee_publication YEAR,
    genre VARCHAR(100),
    isbn VARCHAR(20) UNIQUE,
    restriction_age INT DEFAULT 0,-- NULL si accessible à tous
    professeur_seulement BOOLEAN DEFAULT FALSE
);

CREATE TABLE Exemplaire (
    id_exemplaire INT PRIMARY KEY AUTO_INCREMENT,
    id_livre INT NOT NULL,
    etat ENUM('BON', 'ABIME', 'PERDU') DEFAULT 'BON',
    statut ENUM('DISPONIBLE', 'EN_PRET', 'RESERVE', 'LECTURE_SUR_PLACE') DEFAULT 'DISPONIBLE',
    FOREIGN KEY (id_livre) REFERENCES Livre(id_livre) ON DELETE CASCADE
);

CREATE TABLE Pret (
    id_pret INT PRIMARY KEY AUTO_INCREMENT,
    id_exemplaire INT NOT NULL,
    id_adherent INT NOT NULL,
    type_pret ENUM('DOMICILE', 'SUR PLACE') NOT NULL,
    date_pret DATETIME NOT NULL,
    date_retour_prevue DATETIME NOT NULL,
    date_retour_effective DATETIME,
    prolongation_count INT DEFAULT 0,
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire) ON DELETE CASCADE,
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE
);


CREATE TABLE Reservation (
    id_reservation INT PRIMARY KEY AUTO_INCREMENT,
    id_exemplaire INT NOT NULL,
    id_adherent INT NOT NULL,
    date_reservation DATETIME NOT NULL,
    date_retrait_prevue DATE NOT NULL,
    date_expiration DATETIME NOT NULL,
    statut ENUM('EN_ATTENTE', 'VALIDEE', 'ANNULEE', 'EXPIREE') DEFAULT 'EN_ATTENTE',
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire),
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent)
);


CREATE TABLE Prolongement (
    id_prolongement INT PRIMARY KEY AUTO_INCREMENT,
    id_pret INT NOT NULL,
    date_demande_prolongement DATETIME NOT NULL,
    nouvelle_date_retour DATETIME NOT NULL,
    statut ENUM('EN ATTENTE', 'VALIDE', 'REFUSE') DEFAULT 'EN ATTENTE',
    FOREIGN KEY (id_pret) REFERENCES Pret(id_pret)
);

CREATE TABLE Penalite (
    id_penalite INT PRIMARY KEY AUTO_INCREMENT,
    id_adherent INT NOT NULL,
    id_pret INT, 
    date_debut_penalite DATE NOT NULL,
    date_fin_penalite DATE NOT NULL,
    raison VARCHAR(255),
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE,
    FOREIGN KEY (id_pret) REFERENCES Pret(id_pret) ON DELETE SET NULL
);

CREATE TABLE jour_ferie (
    id_jourferie INT PRIMARY KEY AUTO_INCREMENT,
    date_ferie DATE UNIQUE NOT NULL,
    description VARCHAR(255),
    regle_rendu ENUM('avant', 'apres') DEFAULT 'avant'
);


INSERT INTO jour_ferie (date_ferie, description, regle_rendu) VALUES 
('2025-01-01', 'Jour de l\'An', 'avant'),
('2025-03-08', 'Journée internationale des femmes', 'avant'),
('2025-03-29', 'Commémoration des martyrs', 'avant'),
('2025-05-01', 'Fête du Travail', 'avant'),
('2025-06-26', 'Fête de l\'Indépendance', 'avant'),
('2025-08-15', 'Assomption', 'avant'),
('2025-11-01', 'Toussaint', 'avant'),
('2025-12-25', 'Noël', 'avant'),
('2025-04-18', 'Vendredi Saint', 'avant'),
('2025-04-20', 'Pâques', 'avant'),
('2025-05-29', 'Ascension', 'avant'),
('2025-06-08', 'Pentecôte', 'avant');

INSERT INTO Livre (titre, auteur, editeur, annee_publication, genre, isbn, restriction_age, professeur_seulement)
VALUES ('Livre Test', 'Auteur Test', 'Editeur Test', 2020, 'Fiction', '1234567890123', 0, FALSE);

INSERT INTO Exemplaire (id_livre, etat, statut)
VALUES (1, 'BON', 'DISPONIBLE');

INSERT INTO Profil (type_profil, duree_pret, quota_pret, quota_prolongement, quota_reservation, duree_penalite) VALUES
('Etudiant', 7, 3, 1, 2, 10),
('Professionnel', 14, 5, 2, 3, 15),
('Professeur', 30, 3, 3, 5, 7);


INSERT INTO Adherent (id_profil, nom, prenom, email, telephone, statut, date_naissance, quotat_restant)
VALUES (1, 'Dupont', 'Jean', 'jean.dupont@example.com', '1234567890', 'ACTIF', '2000-01-01', 3);

INSERT INTO Abonnement (id_adherent, date_debut, date_fin, montant, statut)
VALUES (1, '2025-06-01', '2026-06-01', 50.00, 'ACTIVE');

-- Insert reference data for profiles

CREATE TABLE User (
    id_user INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('ADHERENT', 'BIBLIOTHECAIRE') NOT NULL,
    id_adherent INT, -- NULL pour les bibliothécaires
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE
);

INSERT INTO User (email, mot_de_passe, role, id_adherent)
VALUES ('jean.dupont@example.com', 'ad1', 'ADHERENT', 1);
INSERT INTO User (email, mot_de_passe, role, id_adherent)
VALUES ('bibliothecaire@example.com', 'bibli1', 'BIBLIOTHECAIRE', NULL);

ALTER TABLE Adherent ADD quota_restant INT DEFAULT NULL;
UPDATE Adherent a
SET a.quota_restant = (SELECT p.quota_pret FROM Profil p WHERE p.id_profil = a.id_profil);


-- donne de test reservation et recherche :
-- Ajout de livres supplémentaires
INSERT INTO Livre (titre, auteur, editeur, annee_publication, genre, isbn, restriction_age, professeur_seulement)
VALUES 
('Histoire du Monde', 'Marie Curie', 'Editions Universelles', 2018, 'Histoire', '9876543210987', 12, FALSE),
('Physique Quantique', 'Albert Einstein', 'Sciences Press', 2022, 'Science', '4567891234567', 16, TRUE),
('Roman d\'Amour', 'Jane Austen', 'Romantique Editions', 2019, 'Romance', '7891234567890', 0, FALSE);

-- Ajout d'exemplaires supplémentaires
INSERT INTO Exemplaire (id_livre, etat, statut)
VALUES 
(2, 'BON', 'DISPONIBLE'), -- Exemplaire pour "Histoire du Monde"
(2, 'ABIME', 'DISPONIBLE'), -- Deuxième exemplaire pour "Histoire du Monde"
(3, 'BON', 'DISPONIBLE'), -- Exemplaire pour "Physique Quantique"
(4, 'BON', 'DISPONIBLE'), -- Exemplaire pour "Roman d'Amour"
(4, 'BON', 'EN_PRET'); -- Deuxième exemplaire pour "Roman d'Amour" indisponible

-- Mise à jour des quotas restants pour les nouveaux adhérents (si ajoutés)
INSERT INTO Adherent (id_profil, nom, prenom, email, telephone, statut, date_naissance, quota_restant)
VALUES 
(2, 'Martin', 'Sophie', 'sophie.martin@example.com', '0987654321', 'ACTIF', '1995-05-15', 5),
(3, 'Leroy', 'Pierre', 'pierre.leroy@example.com', '1122334455', 'ACTIF', '1980-03-10', 3);

INSERT INTO Abonnement (id_adherent, date_debut, date_fin, montant, statut)
VALUES 
(2, '2025-06-01', '2026-06-01', 60.00, 'ACTIVE'),
(3, '2025-06-01', '2026-06-01', 70.00, 'ACTIVE');

INSERT INTO User (email, mot_de_passe, role, id_adherent)
VALUES 
('sophie.martin@example.com', 'ad2', 'ADHERENT', 2),
('pierre.leroy@example.com', 'ad3', 'ADHERENT', 3);

explications :
Penalite => non rendu de livre
globale pour tous ou par type de profil d'adherent ? => pour tous le monde mais chacun a son nombre de jour par profil, on aprametre : par exemple ce profil 10j ou 20j ou ...
Par contre, y'a des cas : par exemple on est 1er juillet, et il a 2 livres, pret en cours, l'un doit etre rendu 2juillet et l'autre 10juillet et il a pas rendu celui de 2juillet
donc il peut pas prendre de livre que le 12juillet 
et arriver la date de rendu du 2eme livre 10juillet et il l'a pas encore rendu donc + 10j de penalité encore, c'est pas a partir de 10Juillet qu'on fait + 10j de penalité mais sur sa date de sanction 12Juillet donc ca devient 22juillet qu'il peut reprendre

cotat {
    par profil
    ce profil peut prendre 5 ou 3 nombres de livre
}

nombre de prolongements parallere à parametrer {
    ne peut pas faire prolongements de pret 3 en meme temps
    y'a pas de pret prolonger 3 en cours
    on doit savoir quand ce pret en cours si c'est prolonger ou pas car on limite le pret
    si c'est pret normale peut prendre 5
    et on lui dit qu'il ne peut faire de prolongement que 2 de ces prets
    donc 3 prets normale et 2 prets prolongées par exemple 
}

cotat non renouveler => parametrer
pret => cotat dans la base en cours 

interface ou script dans bd => update de cotat

Pa rapport a la penalité c'est apres qu'on l'ait rendu qu'on compte les jours de penalisation ou ?
=> y'a un livre qui devrait etre rendu un 1er Juillet or il l'a rendu que le 3Juillet donc c'est à partir du 3Juillet qu'on compte et qu'on ajoute les jours de penalisation dans la base
=> s'il a pas pu rendre celui apres et quand il le rend enfin, c'est encore + 10j donc à partir de 13Juillet qu'il peut reprendre
et si par exemple il a encore un autre livre qu'il devrait rendre le 5Juillet or il l'a rendu le 8Juillet alors ses jours de penalisation sera compter a partir de 12Juillet veille de penalisation de celui d'avant

donc il sera penalisé
si par exemple il devait rendre un livre le 7 Juillet mais que le 8 Juillet il va prendre un autre livre => alors il peut car y'a encore un livre qu'il n'a pas encore rendu par contre => la sanction ne commencer(effective) a qu'a partir
du jour qu'il aurait rendu le livre

abonnement => date seulement, ici jusqu'ici il est abonner 
inscription => abonnement

bibliothecaire dit juste ce adherent est abonner ici jsqu'à tel date
adherent a login et mdp peut entre dedans mais ne peut rien faire

renouvellement d'abonnement => on a seulement besoin de periode(date)

cotat => 3livres, il a pris 1 sur 3, et ce 1 doit etre rendu 10Juillet et il l'a pas encore rendu et le 11Juillet il veut prendre un livre => ne peut pas car il a pas encore rendu celui qu'il devait rendre a sa date prevu de retour 

mais ne peut rien prendre s'il est pas abonner
cotat lier au profil

----*-----
reservation peut etre accepter et peut ne pas etre accepter par le bibliothecaire, le systeme ne met pas des regles
et meme s'il accepte ca ne devient pas directement un pret mais l'adherent durant la date jour j de la reservation 
devrait preter le livre => et c'est là que tous les regles de gestion entrent => annuler reservation dans ce cas

----*-----
reservation => quotat
prolongement de pret => quotat
quotat et tarif pareil 

il peut toujours voir l'etat ou la fiche de l'adherent mais on ne voit pas les regles dans l'accepation ou recu de reservation mais c'est juste le bibliothecaire qui dit s'il accepte ou s'il le revise

jour ferier => weekend et jour ferier ensemble {
    check dans une table => OUI ou non
    change avec ca date retour
    c'est a nous de choisir ou le faire, au moment du pret ou ...

}

reservation et pret en retard => ne sont pas liés
Retard {
    t'es en retard et tu veux prendre un livre (exemplaire) => tu peux pas
    s'il y'a une reservation deja accepté et que tu veux rendre en pret => tu ne peux pas => pareil que pret normale car prend deja les regles de gestion du pret a la minute ou tu veux rendre en pret
}

le livre reste juste reserver => meme si c'est un adherent sanctionner qui l'a reserver, par exemple la reservation a deja ete accepter mais le bibliothecaire peut faire des recherches et il peut refuser 
un tel ou telle reservation

s'il y'a une reservation et que tu n'a pas rendu un livre => n'est pas transformé en pret, et si y'a une reservation deja accepter et que tu veuille en faire un pret => ne peut pas si tu n'a pas encore rendu de livre 
livre => reserver => meme si l'adherent est sanctionner

la bibliothecaire peut faire des recherches qu'il annule les reservations

2.
Gestion de Bibliotheques
Modules ou grandes lignes des fonctionnalités  {
}

Livre => y'a des livres qui ne peuvent etre emprunter a domicile que par les professeurs par exemple
Exemplaire de livre
Pret: Lecture sur place, maison
Adherent: Etudiant, Professionel, Professeur => regles de gestion differents, regles de gestion peut se porter sur duree de pret et nombre de livre emprunter
Penalite 
Cotisation ou Inscription
reservation/profil par type pret si c'est encore disponible
prolongement
gestion jour ferie


restriction de livre {
    age 
    livre peut pas etre empreinter par des adherents de moins de 18ans
   
 mais apart on peut tous empreinter
}

Si tu rends pas livre => penalisation => peut pas prendre un livre pendant un certain temps => et durée parametrable => depend du profil

Carte membre valide que pour une durée limitée {
    paiement => valide de là jusque là
    sans reabonnement tu peux pas prendre de livre
}

3.
formulaire rendre livre => date
et on fera une date posterieur au date de retour prevu => sanctionner adherent
et si c posterieur avec la date de retour prevu de l'exemplaire, appliquer => sanction
a partir du date qu'on a rendu le livre que la sanction commence et non la date du jour

reservation sesulement adherent avec date et 1 livre

interface bibliothecaire => accepter ou refuser reservation
il peut refuser ou accepter
un livre => peut avoir plusieurs reservations de memes ou differentes dates

et puis tombe enfin le jour ou la reservation sera un pret(ce que seul la bibliothecaire peut faire
) alors c'est la que les regles de gestion du pret entrent en jeu egalement

seulement bibliothecaire peut faire un pret
user => reservation et prolongement seulement mais passe encore par la validation du bibliothecaire


demande prolongement => pret en cours => changer ou modifier en prolonger
 recheche => reserver

difference entre reservation accepter et devenu pret
accepter {
    par exemple il fait une reservation pour le 30Juillet et le bibliothecaire n'accepte ou ne refuse le 15
    si il refuse => augmente le reste de reservation qu'il peut faire 
    si il accepte => il ne peut plus faire de reservation car ca entre deja dans les "reservations en cours"
    15 juillet => accepter
    30 Juillet => devient un pret
    c'est la difference
}


acceptation du bibliothecaire => change directement en pret 
a partir date fin du date prevu => il commence de la pour faire + xx jours

4.
script de reinitialisation de bd {
    drop de tous les elements dans la base
    creation
    doit avoir tous les contraintes dans la base
}

diferent de script d'insertion de donnee de reference '(
    donne ou on en pas et dont on a pas besoin de crud
    inserer dans une table directe
    drop table dans un script
)

prinicipe de fonctionallite a implementer et les autres jjsute a insere directe
donne de test c'est a nous e l creer[
     cet adherent je le fais non abonner et si il emprunte des livres et il devrait avoir un erreur et il ne devrait pas pouvoir faire un pret car son abonement sera fini
     
]

.tous ce qu'on a fait => regles de gestion => devrait avoir des données correspondants pour faire des test apres

5. 
alea => une seule fonctionalite

10h a 17h => jeu de donnee test

donne de reference et donne non referencié exemple adherent
d'autres dans l'interface et d'autres en insert
test de tous les scenarios

fonctionalite principale devrait avoir de l'interface


interface de creation d'adherent utile et non utilisateur

spring boot et mvc

creation de repository => a chaque changement => commit => demande de Pull Request => merge

Cotisation => pas de penalité
penalisation => non retour de livre


-----27/26/25------------
Les trucs que notre prof corrigerai :
Pull Request
Conception de base de données => MPD = Model Physics de Données => si y'a une faute on a pas de note haute
ecran liste de tous les Pull Request qu'on fera

cotisation => pas de penalité
mais il peut dire j'ai plus d'abonnement c'est fini aujourd'hui et il n'est pas penalisé

penalisation => non retour de livre seulement

6.
quota par profil
livre/exemplaire => on peut mettre regle par rapport au profil ou age

renre un livre {
    date

    si posterieur date de retour prevu de l'exemplaire => sanction
}


reservation => simpl

7.
Nom(Titre) : Preter un (exemplaire) livre
Objectif : textuelle ...
Acteur(Utilisateur) : (profil) bibliothecaires
Entrée(INPUT) : ref ex, ref adherent(cota peut etre obtenu via ceci) => qu'est ce dont on a besoin pour traiter la fonctionnalité, iformations ? données ?
Scenario nominal :description fonctionnel d'un cas d'utilisation, description interface,  evenement lier a la fonctionnalité <= c'est ce que regarde les frontend developper, car dans backend developper, il n'a pas besoin de savoir comment on va utliser cette fonction car il a seulement besoin de le créer mais si il va faire full stack c'est là qu'il en a egalement besoin
                  (Acteur) se connecte 
                  Va 'a menu' Preter un livre
                  Remplir champ "adherent", "exemplaire"
                  Cliquer sur le bouton "Enregistrer"
                  exemplaire preté par l'adhérent
                  

CAHIER DES CHARGES : les fonctionnalités devraient etre dans les couches service
Regle de gestion par rapport à pret d'un livre par un adherent (les checks a faire dans une fonction) (fonctionnalité = USE CASE = cas d'utilisation) = description fonctionnel des cas d'utilisation : => se rapporche de la description de la methodologie de UML, quoi que ne suit pas à 100% la methodologie d'UML, mais on peut quand meme expliquer un fonctionnalité
    -adh doit etre actif
    -adh existe (son numero)
    -exemplaire disponible
    -quota ?
    -sanction adherent ?
    -adherent abonné ? 
    -exemplaire existe
    -adherent peut prendre l'exemplaire ? => regle au niveau livre
    -adherent age ? regle associé @exemplaire ? si y'a une regle approprié pour l'age de l'adherent ?
    -etc

Scenario alternative a la regle de gestion : => plutot interface
si la(es) regle(s) de gestion n'est pas satisfait : si y'en a une qui n'est pas satisfait
affichage message d'erreur => rediriger page d'acceill
avec cause d'erreur 
si c'est sanction, on affiche => jusqu'a tel date 
expiration abonnement => date si l'adherent n'est plus abonnée
restriction a propos de l'age => et toi tu n'en fais pas encore partie
.toujours dire les causes des erreurs

RESULTAT : cette partie qu'on ecrit les test unitaires => details de chacun des cas
Si tous les regles de gestion sont satisfait {
    (
        adherent inactif => erreur
        adherent augmente +1 => son pret
        adh -1 (nmbre de livre qu'il peut prendre)(quota)
        exemplaire => indisponible =>jusqu'au date associé a date duree de pret de l'adherent
        
    )
Sinon : on throws exception
    (
        Si
            adh prend un exemplaire          >18, on prend comme ceci tous les cas
            => message d'erreur=> quota ex: ne diminue pas, livre reste la meme etat, 

            adh sanctionner => message d'erreur
            pret non fini => etat avant, si on prend un exemplaire disponible il sera toujours disponible 

    )
}

devrait etre fais dans une couche Service

implementation de cette methode => on connait deja ce qui va se transformer en argument (regle de gestion), interface (scenario nominal, alterantif et resultat)

conception => le plus difficile

test unitaire => interface (y'a un outil) => remplissage de formulaire => fait un submit et test automatiquement
test unitaire de methode => methode de service ou couche service
doit avoir une classe de test : PretServiceTest; methode => PreterLivre => PreterLivreTest
dans PreterLivreTest {
    on fait select pour appeler serviceDAO dans la coucheDAO, faire une select : donne moi l'adherent => qui est à la fois actif, a encore du cotat et peut
    prendre ce livre
    et on prend le livre et on appelle PreterService(PreterLivre) et on lui donne l'argument et apres on verifie, comment ? tous ce qui est ecrit => 
    tester puis on va dans la base => on appelle vers la base, cet adherent combien de livres restant, il peut prendre => devrait diminuer d'1
    .avant preterLivre on devrait savoir le numero d'exemplaire disponible, on lance le preterLivre et apres on verifie qu'il n'est plus dispo, et sa date =>
    date du jour(date de retour du livre) + nmbre de durée de pret associé au profil de l'adherent => implementation serieux de fonctionnalité
}

Test avant implementation
au lieu de faire if, dans la base on doit toujours prendre, appel de PreterLivre on doit toujours faire mais le faisage de if 
on peut utiliser des fonctions condensées , des assertions qui font generalement des asserts

librairie ou framework=> test unitaire JUNIT si on utilise JAVA, Test ng, peut etre coupler dans le projet et on declare class de test 
par le biais des annotations, on lance pas un par un les méthodes car ils sont plusieurs et c'est là le travail des framework de tester les term
un clic et il balaye les classes declarées test et il appelle un par un les classes de test et il fait un rapport si c'est 100% successfull ou non (failed)
et il dit ce qui ne vas pas => assurer que les fonctionnalités marchent vraiment et assurent la robustesse de l'application qu'on fait => ecriture de test unitaires

8.
projet reel plusieurs dans un an
licence => entreprise => experience => projet d'ecole 
en parallele => PROjet perso

Gerer {
    Gestion de Bibliotheques {
        modules : grandes lignes des fonctionnalités
        {
            y'a livre, exemplaire de livre, pret (sur place, exterieur), 
            on separe les adherents car les regles de gestion ne sont pas pareil
            ex : Les regles de gestioen Etudiant peut se porter sur les durées de pret et nmbre de livre qu'il peut prendre
            livre => ne peut etre emprunter que par des + 18 ans
            si tu rends pas le livre => Penalite => tu peux pas prendre de livre pendant un certains temps et le duree aussi
            
        }
    }
}

9.
1/ reservation {
    y'a quelqu'un qui peut reserver un pret et qui dit moi je veux emprunter ce livre a ce date,
    par profil nombre de livres qu'il peut reserver et par rapport au type de pret egalement
    basé aussi sur la disponibilité du livre
    ex : livre reserver 7 juillet 
    .adherent quand il rentre dans le systeme savent quand tous les exemplaire sur ce livre revienne
    et il voit par exemple 6juillet tous les exemplaire reviennent ou qu'un seule exemplaire est disponible(revienne)
    bah il peut reserver pour 7juillet => demande de reservation qu'il fait
    et ce livre n'est pas encore reserver, besoin de Bibliothecaire pour valider(accepter) la reservation
    et quand c'est accepter par le Bibliothecaire => le livre devient indisponible quand y'a un autre adherent qui fait la recherche de cet
    exemplaire et son etat devient => "reserver"
    etat => disponible, en pret, reserver, en lecture sur place => 4etats des exemplaires
    ce n'est que quand c'est disponible qu'on peut en faire un pret

    et vint la personne ou l'adherent le 7juillet pour dire qu'il en a deja fait la reservation de l'exemplaire en question
    et le Bibliothecaire voit directement qu'il l'a reserver et le livre ou l'exemplaire devient non disponible et l'exemplaire 
    devient pret en "domicile" par contre si la personne ou l'adherent ne vient jusqu à la tombée du jour, le lendemain l'exemplaire redevient dispo

    RESERVATION / par profil
}

 2/ PROLONGEMENT PAR PROFIL egalement {
    c'est par profil qu'on peut dire qu'il peut le faire et s'il peut le faire alors combien de fois il peut faire le prolongement et combien d'exemplaires
    il peut faire en parallele de prolongement de pret
    .Par exemple si le pret doit etre terminer 28 juin
    on peut aussi dire la date de demande de prolongement, exemple 2jours a l'avance et le "2" est parametrer et s'il dit 2j ou 48h a l'avance(fin 
    de pret), il demande de prolonger le pret car il va pas le rendre le 28juin
    et c'est le Bibliothecaire qui valide ce prolongement mais y'a aussi des regles de gestion qui sont placées qu'on ne peut pas demander des prolongements si 
    tu as atteint tes quotas et si tu n'a pas la permission => le bouton prolongement de pret n'est juste pas disponible(desactiver) dans ces cas là
    .Les adherents rentrent et ils voient directe la liste de leurs prets en cours et seuls ceux qui sont autorisées et possible de prolongement => y'a deja le bouton prolonger le pret a coté sinon c'est pas possible
    .tu demandes un prolongement => valider par le Bibliothecaire => apres validation du Bibliothecaire => si c'etait 28juin que le livre devait etre rendu mais que ta durée est de 7jours 
    alors le livre peut finalement etre rendu et etre disponible le 5juillet, date de rendu prevu apres prolongement de pret

 }

 3/ Gestion de jour ferié {
    par exemple tu as prevu de rendre un livre un 26juin or la Bibliotheque est fermé donc devrait stocker tous les jours feries dans le systemes donc si le livre n'est pas rendu le 26juin alors tu ne
    seras pas penalisé car meme la Bibliotheque etait fermé, regle qui doit etre contenu => parametres => avant ou apres qu'il doit etre rendu et le Bibliothecaire est libre de mettre ces 
    conditions, s'il le fait avant et que tu prends un livre qui devrait etre rendu le 26juin alors il te dit de le rendre 25juin apres avoir fais ton pret, il fait un recap et te dit que tu dois le 
    rendre 25Juin car on est feriées le 26juin mais si on fait moins alors date anterieur c'est-a-dire jours ouvrables plus proche antérieurement, par exemple si c'est lundi de pentecote que tu 
    aurais du rendre le livre et que si la regle choisit est celui d'antérieur alors vendredi avant lundi de pentecote que tu dois rendre le livre si la Bibliotheque ne travaille pas samedi mais
    samedi s'ils travaillent quand meme 


 }

QUESTION DES ELEVES :
si par exemple y'a quelqu'un qui veut prolonger la date de rendu de pret de son livre or un autre adherent ayant vu la date de disponibilité a deja reservé le livre en question et a deja ete valider
par le Bibliothecaire alors l'autre adherent ne peut plus prolonger le livre car c'est toujours celui valider par le Bibliothecaire en premier qui est prise en compte

prolongement => parametrer absolument
tous ce qu'on fera dans ce projet sera parametrables => car c'est cela un projet réel,aucun parametres dans les codes sources au pire fichier de configuration ou base et a un interface de configuration

regles de jour ferié => par Bibliotheque ou par pret ? la reponse est par Bibliotheque et si l'Etat dit par exemple on est feriés a ce jour ou tel jour alors on introduiera dans le systeme ce jour en question
et tous les prets contractés avant qu'on ait inserer ce nouveau jour ferié => change tous directement car par exemple il devait etre rendu en ce nouvel jour ferié meme or on vient d'introduire que ce jour etait
ferié alors il devrait etre rendu avant ou apres dependra du parametrages qu'on aurait fait pour le jour ferié



Synthetiser 
documents avec toutes les fonctionnalités
methodologie de developpement

evident => doit avoir un dashboard, recherche avancé, livre le plus emprunter, livre le moins emprunter, detailler
quel est l'indicateur qu'on placera pour les statistiques de tableau de bord ou dashboard 

10.
liste de fonctionnalités à faire
comment expliquer ou donner des informations sur les fonctionnalités
Exemple de cas : 1 fonctionnalités :
on lui donne un nom
doit etre infinitif => verbe d'action
exemple : preter un livre/exemplaire

fonctionnalités => un methode dans une couche service
on devrait avoir une classe PreteService et dedans y'a une methode PreterLivre(ref exemplaire, ref adherent)

description de cas d'utilisation qu'on fait en premier et c'est ca que le developper regarde pour etre transformer en code
et l'ensemble de description + fonctionnalités => en grande partie appeler cahier de charge
on implemente preter un exemplaire(reservation d'exemplaire) => on devrait avoir des informations qu'on ecrira=> et c'est ca qui est transformer en code

UML => fonctionnalité => use case ou cas d'utilisation
uml = methodologie pour faire la conception de systeme d'informations, donne bcp de diagramme, issu des besoins, si on veut creer , 1ere chose a faire => requiert de besoin
recueil de besoin par le biais d'entretien(discussion environnement client, analyse de l'existant), etc apres => cahier de charge => besoin fonctionnel => liste et description fonctionnalités, besoin fonctionnels
demande du client en terme de fonctionnalités futur du systeme
listé fonctionnalités => on peut utiliser avec le cahier de charge => norme UML(à quelque chose pres) pour decrire chaque fonctionnalités, peut ne pas l'utilser mais utiliser d'autres canevas
exemple textuelle ou excel

ensemble DE CELA => grande partie => cahier de charge
cahier de charge => besoin fonctionnels et besoins non fonctionnels(doivent etre mis dans le cahier de charge) => conception 
.besoins non fonctionnels {
    entretien => requiert de besoin, pas forcement un entretien peut etre le client fourni un document, dans le requiert des besoins,
    on peut voir qu'y a des exigences, y'a d'autres besoins mais qui ne sont pas fonctionnels (durée de chargement de page, chart graphique,
    par exemple des exigences comme faut utiliser dotnet car on a une license microsoft => devrait etre mise dans le cahier de charge)
} 

conception (architecture, technologies) { => en general conception relationnelle
    donnees
    traitement
    => UML peut entrer dans l'expression et la presentation de la conception
    conception relationnelle, on peut faire diagramme MPD (Model Physic de Donnee)
    concepteur => on peut utliser schema proposé par UML pour remplir le document de la
    conception
    comment faire la conception de traitement de ceci => le notre, on ne demande pas encore ca maintenant
    mais on peut tres bien l'exprimer avec les diagrammes d'UML (UML a 9 diagrammes)
    conception => on a besoin d'exprimer la conception par rapport aux besoins ou exigences ecrit dans le cahier de charges
    peut ne pas etre shematiser mais seulement textuelle 
    exemple : table : colonne
    reponse de la conception exprimer par nous humain, peut etre textuelle, schematiser
    schema => plus rapide a lire et a comprendre, proposé par UML aux différentes etapes que ca soit au niveau cahier de charge,
    traitement, conception, deploiement qu'on peut utliser pour faciliter la presentation de ce qu'on veut afficher que ca soit au niveau des
    cahiers de charge ou conception relationnelle ou traitement ou deploiement => c'est le but de UML
}

cas d'utilisation => cahier de charges

diagramme de cas d'utilisation => liste de fonctionnalités, au lieu de lister on fait cas d'utilisation par Acteur
Par exemple Acteur Bibliothecaires {
    il peut preter un livre/exemplaire
    rendre un livre
    ajouter un adherent
}
important => qu'on ait finit de decrire les fonctionnalité

description des fonctionnalités {
    qui profil peut ...
    creer type de pret (
        peut etre sur place ou a domicile => on doit avoir une table fonctionnalité 4 CRUD
    )
    a plusieurs regles de gestion doivent etre decrits correctement
}


11.
Methode de travail dans git qu'on parlera dans ce projet et dans le projet en S5
Approche {
    mais qu'on ne trouvera pas forcement dans le monde du travail
    il peut marcher que ca soit sur :
    github
    ou gitlab
}

technologies => un peu different mais c'est a nous de les rechercher
normalement y'a toutes les Fonctionnalites dans github et gitlab

quand on aurait fini les listes de Fonctionnalites et les descriptions de ces listes de Fonctionnalites consequentes
on devrait maintenant decider de qui faire en premier genre develloper en preums
toutes les fonctionnalités n'ont pas besoin d'interface
et on devrait egalement decider lequel a besoin d'interface ou d'ecran
on peut juste faire select ou script et non des plusieurs de CRUD mais la plupart devrait juste etre en script
mais pour de vrai,  les Fonctionnalites qu'on a mis des descriptions detaillées devront etre implementer en general les autres juste script d'insertion seulement

on devrait arranger ce qu'on devrait faire en premier quand on aurait fini la liste des fonctionnalités et on arrangera ce qu'on fera en premier, les fonctionnalités tous ça
quand on trouvera cela, peut etre 1 ou 2 on les assemblera, voici ce qu'on devrait faire en preums, et ca peut etre un seul seulement et c'est pas grave, dans notre cas c'est pas grave
peut par exemple ne faire d'abord qu'une fonctionnalité de recherche MULTICritere de livre

Chaque fonctionnalités {

    voici les cycles qu'on devrait faire :
    les futurs fonctionnalités qu'on fera
    creation d'une branche main ou principale(repository) dans github
    on travail => on clone la branche
    clone => nom => correspondant au nom du fonctionnalités (exemple :  futur...) => devrait vraiment correspondre aux fonctionnalités

    on travail :
    dans un cadre de spring, peut avoir plusieurs fonctionnalités
    exemple on ne fera qu'1 seul fonctionnalités
    on commitera apres avoir travailler le soir ou qu'on vient de travailler ou de finir quelque chose
    on peut tester localement 

    quand on est satisfait et qu'on a bien fini les fonctionnalités => on commit

    on finit modele, repository, controller, a chaque finission d'etape on peut commite
    ce n'est qu'a la fin qu'on teste localement si ca marche ou pas
    et normalement on devrait directement merger ce "main" mais on ne fait pas de "merge" mais on fait "PR" ou "Pull Request"
    "PR" = veut merger ces modifications, modif dans ces commit, on demande à merger, demande de merge
    c'est vrai que dans ce projet on est responsable individuellement mais dans le monde réel(du travail), notre travail est develloper, on clonera la branche principale on nous donnera les fonctionnalités a implémenter
    beaucoup de dev chacun son travail et on a besoin de ce "PR" pour demander a merger et on peut voir dans l'interface qu'on se demande un merge par rapport à une branche
    et on demande à etre valider
    ce branche => tous les modifs ici j'aimerais le merger dans cette branche principale
    Demande de "PR" et non directe => merge


    on regardera plus tard les listes de "PR", description => bien claire toujours correspondant aux noms des fonctionnalités,

    reel {
        equipe dans un devellopment info  technologies utiliser => tres agile, par exemple le projet est ce projet de bibliotheque, pas directement attaquer mais par exemple commencer par le module gestion de livre 
        gestion livre non use case mais module et dedans y'a plusieurs use case ou cas d'utilisation et on choisit parmis ces cas d'utilisation par exemple develloper 1 va ajouter des livres et une autre va faire la recherche, etc
        et cela dans une duree determiner, generalement en 2semaines c'est normalement la durée d'une sprint(ensemble d'une fonctionnalité), choix d'un sprint, commencement et finit jusqu' au test et deploiement
        client test => anomalie => retour, satisfait => prochaine fonctionnalité
        equipe dedans => y'a des roles => postes => TL
    }

    
    nouvelle fonctionnalité => nouvelle branche => clone => fait des modifs => pull request => merge
    PR qu'il regarde, apres cela on supprime le branche car on en a plus besoin, pas besoin de beaucoup de branches mais seulement branche en cours et branche principale


   
}



Fonctionnalites {

    recherche MULTICritere de livre
}


.soutenance {
    y'a plusieurs points : à eviter :
        -ne pas parler que de code, dans livre, presentation
        -or il a fait configuration reseau, server et bcp d'autres choses qu'il a pas dit 
        -car on a tendance a penser que travailler = coder seulement
        -description textuelle => bien ecrire dans le livre = temps d'ecriture d'une partie de cahier de charge, voici les fonctionnalité que j'ai eu à ecrire
        -formation => planning =>  nombres de jour, redaction manuelle user => nnbre de jour mais pas seulement code vu que le code c'est deja notre travail avec 
        requiert de besoin, etc donc pas seulement focus concernant le code
        -comment on a gerer CICD

} 

integration continue => continue avec deploiement continu {
    branche => clone => travail => commit localement => on travail sur la fonctionnalité => modif => commit => PR => on accepte => merge @ branche principale
    liste PR qu'il regardera
}

code non performant {
    boucle inutile 
    variable inutile
}

comment faire quand y'a deploiement  {
    quand on a finit sprint en cours {
        deployer => generalement => y'a 2envir minimum deploier app {
            env de test
            env de production
            les merges de tous les develloper sont finis => deploiement de fonctionnalité develloper dans le sprint => creation de branche release
            et dans release {
                deploiement dans staging(env de test)
                dans enviro staging => clone release et il l'a => peut compile et tous <= exemple, mais y'a deja des outils pour faire des deploiement => deploiement continu
                clone simple => on a derniere version => on connait l'url release => creation branche release => on test => si y'a un probleme => 
                test => y'a un probleme => alert au dev du probleme sur ce qui ne marche pas => creation de branche issu de main (dans le branche, on met BugFiles avec num de ticket car la plupartes des bugs fais dans le staging, c'est
                le testeur qui fait le test, dans une equipe y'a dev TL et QA(Quality Assurance) et ce sont les QA qui font le test ce ne sont pas des deve et la majorité des femmes => creer ticket)
                ticket => app gerer les futurs fonctionnalité generalement => "traineau, JiRA" => app qui gere
                et dedans on dit voici les fonctionnalité dans ce sprint => ticket et y'a des num et assignés aux deve
                bugs => creation d'un nouvel ticket 
                creation branche => commit => test local => PR => TL decide s'il faut merger ou pas, si oui merger dans main(branche principale) mais en meme temps les modifs doivent etre envoyees aux branches release car c'est la branche 
                qui va etre tester dans le staging vu qu'on ne peut pas encore faire merger des modifs a plusieurs branches mais seulement branche principale que tu demaned par le biais de PR mais apres dans l'interface y'a Cherry pic, PR appeler
                Cherry Pic, prend le changement dans le PR et envoie et applique dans cette branche release, Cherry Pic a une source(changement de le PR) et destination(branche du release en cours) et il prend tous les modifs et ils appliquent dans
                le release et ils redeploient et QA reteste et si c'est pas encore satisfait on recommence jusqu a etre satisfait, dans l'environnement staging ou de test ou preprod, on demande le deploiement du release dans environnement de production
            }
        }
    }
}


demande {
    -PR avant de merge
}

Fonctionnalité {
    gestion = module et non fonctionnalité devrait etre diviser (gestion des adherents)
    verbe d'action
    details

}

EXEMPLE DE FONCTIONNALITE {
    RESERVER UN EXEMPLAIRE
}

    reservation => non disponible a partir de la date de reservation 
    date et heure pour la demande de reservation

    details et reflexions important

quand on fera nos livres => on pourra utiliser ce format qu'on apprend pour illustrer chacun des cas d'utilisation 

12.
On devrait avoir une liste de fonctionnalité par ACTEUR
description OU usecase

Titre
description
ACTEUR
scenario nominal
scenario alternative
resultat

avec tous ces contenus de mon projet et ces explications de mon professeur a votre avis est ce que j'implemente correctement la fonctionnalités de reserver un exemplaire ?
et enfaite j'ai tester ce projet meme et j'ai convertit une reservation en pret dans bibliothecaire mais j'obtiens un erreur :
Unimplemented method 'getTypePret'

Et aussi puisque j'ai un peu lu quand meme les explications de notre prof et j'ai cru comprendre qu'une validation de reservation de la part de la bilbiothecaire nn signifiait pas tout de suite la conversion en pret de cette reservation mais plus tard il a encore changer d'avis,nous a demander et nous avions repondu que apres validation => pret donc je sais plus quoi pesnser 
a votre avis en tenant compte qund meme des explications de mon professeur qu'est ce que je dois faire  