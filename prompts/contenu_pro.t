je en recois qu'un seul resultat :
L'adhérent est sous sanction.

pourquoi n'avez vous pas fais en sorte que tous les resultats s'affichent?
AdminController :
package com.biblio.controller;

import com.biblio.exception.PretException;
import com.biblio.model.Reservation;
import com.biblio.model.User;
import com.biblio.repository.ReservationRepository;
import com.biblio.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private ReservationRepository reservationRepository;

    @GetMapping("/reservations")
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

    @GetMapping("/validatedReservations")
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

    @PostMapping("/validateReservation")
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

    @PostMapping("/rejectReservation")
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

    @PostMapping("/convertToPret")
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

AuthController:
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

import com.biblio.exception.PretException;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.Reservation;
import com.biblio.model.User;
import com.biblio.repository.ReservationRepository;
import com.biblio.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/adherent")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private ReservationRepository reservationRepository;

    @GetMapping("/reservation")
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

    @PostMapping("/reservation")
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
        } catch (PretException e) {
            model.addAttribute("error", e.getMessage());
        }
        List<Exemplaire> exemplaires = reservationService.findAllExemplairesWithLivres();
        model.addAttribute("exemplaires", exemplaires);
        return "reservationForm";
    }

    // Déplacer les mappages admin hors de /adherent
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

PretControlelr :
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



Abonnement.java :
package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "Abonnement")
public class Abonnement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_abonnement")
    private Integer idAbonnement;

    @ManyToOne
    @JoinColumn(name = "id_adherent", nullable = false)
    private Adherent adherent;

    @Column(name = "date_debut", nullable = false)
    private LocalDate dateDebut;

    @Column(name = "date_fin", nullable = false)
    private LocalDate dateFin;

    @Column(name = "montant", nullable = false)
    private double montant;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut")
    private StatutAbonnement statut = StatutAbonnement.ACTIVE;

    public enum StatutAbonnement {
        ACTIVE, EXPIREE
    }

    // Getters et Setters
    public Integer getIdAbonnement() {
        return idAbonnement;
    }

    public void setIdAbonnement(Integer idAbonnement) {
        this.idAbonnement = idAbonnement;
    }

    public Adherent getAdherent() {
        return adherent;
    }

    public void setAdherent(Adherent adherent) {
        this.adherent = adherent;
    }

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    public LocalDate getDateFin() {
        return dateFin;
    }

    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public StatutAbonnement getStatut() {
        return statut;
    }

    public void setStatut(StatutAbonnement statut) {
        this.statut = statut;
    }
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
    @Column(name = "id_adherent")
    private int idAdherent;

    @ManyToOne
    @JoinColumn(name = "id_profil", nullable = false)
    private Profil profil;

    @Column(name = "nom", nullable = false)
    private String nom;

    @Column(name = "prenom", nullable = false)
    private String prenom;

    @Column(name = "email", unique = true)
    private String email;

    @Column(name = "telephone")
    private String telephone;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut")
    private StatutAdherent statut;

    @Column(name = "date_naissance", nullable = false)
    private LocalDate dateNaissance;

    @Column(name = "quotat_restant", nullable = true)
    private Integer quotaRestant;

    public Integer getQuotaRestant() {
        return quotaRestant;
    }

    public void setQuotaRestant(Integer quotaRestant) {
        this.quotaRestant = quotaRestant;
    }

    public enum StatutAdherent {
        ACTIF, INACTIF, SANCTIONNE
    }


    // Constructeurs
    public Adherent() {}

    public Adherent(Profil profil, String nom, String prenom, String email, String telephone, StatutAdherent statut, LocalDate dateNaissance) {
        this.profil = profil;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.telephone = telephone;
        this.statut = statut;
        this.dateNaissance = dateNaissance;
    }

    // Getters et Setters
    public int getIdAdherent() {
        return idAdherent;
    }

    public void setIdAdherent(int idAdherent) {
        this.idAdherent = idAdherent;
    }

    public Profil getProfil() {
        return profil;
    }

    public void setProfil(Profil profil) {
        this.profil = profil;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public StatutAdherent getStatut() {
        return statut;
    }

    public void setStatut(StatutAdherent statut) {
        this.statut = statut;
    }

    public LocalDate getDateNaissance() {
        return dateNaissance;
    }

    public void setDateNaissance(LocalDate dateNaissance) {
        this.dateNaissance = dateNaissance;
    }

    
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
    public LocalDateTime getDatePret() { return datePret; }
    public void setDatePret(LocalDateTime datePret) { this.datePret = datePret; }
    public LocalDateTime getDateRetourPrevue() { return dateRetourPrevue; }
    public void setDateRetourPrevue(LocalDateTime dateRetourPrevue) { this.dateRetourPrevue = dateRetourPrevue; }
    public LocalDateTime getDateRetourEffective() { return dateRetourEffective; }
    public void setDateRetourEffective(LocalDateTime dateRetourEffective) { this.dateRetourEffective = dateRetourEffective; }
    public int getProlongationCount() { return prolongationCount; }
    public void setProlongationCount(int prolongationCount) { this.prolongationCount = prolongationCount; }
    public Statut getStatut() { return statut; }
    public void setStatut(Statut statut) { this.statut = statut; }
}

Profil.java :
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

Reservation.java :
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

       @Column(name = "date_reservation", nullable = false)
       private LocalDateTime dateReservation;

       @Column(name = "date_retrait_prevue", nullable = false)
       private LocalDate dateRetraitPrevue;

       @Column(name = "date_expiration", nullable = false)
       private LocalDateTime dateExpiration;

       @Enumerated(EnumType.STRING)
       @Column(name = "statut", nullable = false)
       private Statut statut;

       @Enumerated(EnumType.STRING)
       @Column(name = "type_pret", nullable = false)
       private TypePret typePret; // Ajout du champ typePret

       // Constructeurs
       public Reservation() {}

       public Reservation(Exemplaire exemplaire, Adherent adherent, LocalDateTime dateReservation, LocalDate dateRetraitPrevue, LocalDateTime dateExpiration, TypePret typePret) {
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
       public LocalDateTime getDateReservation() { return dateReservation; }
       public void setDateReservation(LocalDateTime dateReservation) { this.dateReservation = dateReservation; }
       public LocalDate getDateRetraitPrevue() { return dateRetraitPrevue; }
       public void setDateRetraitPrevue(LocalDate dateRetraitPrevue) { this.dateRetraitPrevue = dateRetraitPrevue; }
       public LocalDateTime getDateExpiration() { return dateExpiration; }
       public void setDateExpiration(LocalDateTime dateExpiration) { this.dateExpiration = dateExpiration; }
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
AbonnementRepository :
package com.biblio.repository;

import com.biblio.model.Abonnement;
import com.biblio.model.Adherent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.Optional;

public interface AbonnementRepository extends JpaRepository<Abonnement, Integer> {
    @Query("SELECT a FROM Abonnement a WHERE a.adherent = :adherent AND a.statut = 'ACTIVE' AND a.dateFin >= :currentDate")
    Optional<Abonnement> findActiveAbonnementByAdherent(@Param("adherent") Adherent adherent, @Param("currentDate") LocalDate currentDate);
}

AdherentRepository :
package com.biblio.repository;

import com.biblio.model.Adherent;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdherentRepository extends JpaRepository<Adherent, Integer> {
}

PretRepository :
package com.biblio.repository;

import com.biblio.model.Adherent;
import com.biblio.model.Pret;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PretRepository extends JpaRepository<Pret, Integer> {
    @Query("SELECT COUNT(p) FROM Pret p WHERE p.adherent.idAdherent = :idAdherent AND p.dateRetourEffective IS NULL")
    long countActivePretsByAdherent(@Param("idAdherent") int idAdherent);

    @Query("SELECT COUNT(p) FROM Pret p WHERE p.adherent = :adherent AND p.statut = :statut")
    long countByAdherentAndStatut(@Param("adherent") Adherent adherent, @Param("statut") Pret.Statut statut);

    @Query("SELECT COUNT(p) FROM Pret p WHERE p.adherent = :adherent AND p.statut NOT IN :statuts")
    long countByAdherentAndStatutNotIn(@Param("adherent") Adherent adherent, @Param("statuts") List<Pret.Statut> statuts);
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

PretService :
package com.biblio.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.DayOfWeek;
import java.util.ArrayList;
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
        List<String> errors = new ArrayList<>();

        // Valider l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent).orElse(null);
        if (adherent == null) {
            errors.add("L'adhérent n'existe pas.");
        } else {
            System.out.println("Adhérent trouvé: " + adherent.getIdAdherent() + ", Statut: " + adherent.getStatut());
            // Vérifier le statut de l'adhérent
            if (adherent.getStatut() == Adherent.StatutAdherent.SANCTIONNE) {
                errors.add("L'adhérent est sous sanction.");
            }
        }

        // Vérifier l'abonnement actif
        LocalDate currentDate = LocalDate.now();
        Abonnement abonnement = (adherent != null) ? abonnementRepository.findActiveAbonnementByAdherent(adherent, currentDate).orElse(null) : null;
        if (adherent != null && abonnement == null) {
            errors.add("Aucune cotisation active trouvée.");
        }

        // Vérifier l'exemplaire
        Exemplaire exemplaire = exemplaireRepository.findById(idExemplaire).orElse(null);
        if (exemplaire == null) {
            errors.add("L'exemplaire n'existe pas.");
        } else {
            System.out.println("Exemplaire trouvé: " + exemplaire.getIdExemplaire() + ", Statut: " + exemplaire.getStatut());
            if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
                errors.add("L'exemplaire n'est pas disponible.");
            }
        }

        // Si des erreurs sont présentes, les combiner et lever une exception
        if (!errors.isEmpty()) {
            throw new PretException(String.join(" et ", errors));
        }

        // Vérifications supplémentaires (seulement si aucun problème jusqu'ici)
        if (adherent != null && exemplaire != null) {
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
            System.out.println("Nombre de prêts actifs: " + activePrets + ", Quota: " + adherent.getProfil().getQuotaPret() + ", Quota restant: " + adherent.getQuotaRestant());
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
        return null; // Ne devrait jamais être atteint si les vérifications sont correctes
    }
}

AbonnementService :
package com.biblio.service;

import java.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.biblio.exception.PretException;
import com.biblio.model.Abonnement;
import com.biblio.model.Adherent;
import com.biblio.repository.AbonnementRepository;
import com.biblio.repository.AdherentRepository;

@Service
public class AbonnementService {

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private AdherentRepository adherentRepository;

    @Transactional
    public Abonnement activerAbonnement(int idAdherent, LocalDate dateDebut, LocalDate dateFin, double montant) {
        System.out.println("Début activerAbonnement: idAdherent=" + idAdherent + ", dateDebut=" + dateDebut + ", dateFin=" + dateFin);

        // Valider l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));

        // Créer l'abonnement
        Abonnement abonnement = new Abonnement();
        abonnement.setAdherent(adherent);
        abonnement.setDateDebut(dateDebut);
        abonnement.setDateFin(dateFin);
        abonnement.setMontant(montant);
        abonnement.setStatut(Abonnement.StatutAbonnement.ACTIVE);

        // Réinitialiser le quota restant
        adherent.setQuotaRestant(adherent.getProfil().getQuotaPret());
        adherentRepository.save(adherent);

        // Enregistrer l'abonnement
        try {
            abonnementRepository.save(abonnement);
            System.out.println("Abonnement activé: " + abonnement.getIdAbonnement() + ", Quota restant réinitialisé: " + adherent.getQuotaRestant());
            return abonnement;
        } catch (Exception e) {
            e.printStackTrace();
            throw new PretException("Erreur lors de l'activation de l'abonnement: " + e.getMessage());
        }
    }
}

ReservationService :
package com.biblio.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;

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
import com.biblio.repository.AbonnementRepository;
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

    @Autowired
    private AbonnementRepository abonnementRepository;

    public List<Exemplaire> findAllExemplairesWithLivres() {
        return exemplaireRepository.findAllWithLivre();
    }

    @Transactional
    public Reservation reserverExemplaire(int idAdherent, int idExemplaire, String typePret, LocalDate dateRetraitPrevue) {
        List<String> errors = new ArrayList<>();

        // Valider l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent).orElse(null);
        if (adherent == null) {
            errors.add("L'adhérent n'existe pas.");
        } else {
            if (adherent.getStatut() == Adherent.StatutAdherent.SANCTIONNE) {
                errors.add("L'adhérent est sous sanction.");
            }
            if (!hasActiveSubscription(adherent)) {
                errors.add("Aucune cotisation active trouvée.");
            }
        }

        // Vérifier l'exemplaire
        Exemplaire exemplaire = exemplaireRepository.findById(idExemplaire).orElse(null);
        if (exemplaire == null) {
            errors.add("L'exemplaire n'existe pas.");
        } else {
            if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
                errors.add("L'exemplaire n'est pas disponible pour la date sélectionnée.");
            }
        }

        // Si des erreurs sont présentes, les combiner et lever une exception
        if (!errors.isEmpty()) {
            throw new PretException(String.join(" et ", errors));
        }

        // Vérifications supplémentaires (seulement si aucun problème jusqu'ici)
        if (adherent != null && exemplaire != null) {
            int age = LocalDate.now().getYear() - adherent.getDateNaissance().getYear();
            if (exemplaire.getLivre().getRestrictionAge() > age) {
                throw new PretException("L'adhérent ne satisfait pas à la restriction d'âge.");
            }
            if (exemplaire.getLivre().isProfesseurSeulement() && adherent.getProfil().getTypeProfil() != Profil.TypeProfil.PROFESSEUR) {
                throw new PretException("Livre réservé aux professeurs.");
            }

            long activeReservations = reservationRepository.countByAdherentAndStatutNotIn(adherent, Arrays.asList(Statut.ANNULEE, Statut.EXPIREE));
            if (activeReservations >= adherent.getProfil().getQuotaReservation()) {
                throw new PretException("Quota de réservations dépassé.");
            }

            LocalDateTime now = LocalDateTime.now();
            LocalDateTime dateExpiration = now.plusDays(7);
            Reservation reservation = new Reservation(exemplaire, adherent, now, dateRetraitPrevue, dateExpiration, Reservation.TypePret.valueOf(typePret.toUpperCase().replace("LECTURE_SUR_PLACE", "SUR_PLACE")));
            adherent.setQuotaRestant(adherent.getQuotaRestant() - 1);
            adherentRepository.save(adherent);
            return reservationRepository.save(reservation);
        }
        return null; // Ne devrait jamais être atteint si les vérifications sont correctes
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
        if (reservation.getExemplaire().getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
            throw new PretException("L'exemplaire n'est plus disponible.");
        }
        reservation.setStatut(Statut.VALIDEE);
        reservationRepository.save(reservation);
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
        LocalDate today = LocalDate.now();
        if (today.isBefore(reservation.getDateRetraitPrevue()) || today.isAfter(reservation.getDateRetraitPrevue().plusDays(1))) {
            throw new PretException("La conversion en prêt n'est possible que le jour de la date de retrait prévue.");
        }
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));
        Exemplaire exemplaire = reservation.getExemplaire();

        List<String> errors = new ArrayList<>();
        if (adherent.getStatut() == Adherent.StatutAdherent.SANCTIONNE) {
            errors.add("L'adhérent est sous sanction.");
        }
        if (!hasActiveSubscription(adherent)) {
            errors.add("Aucune cotisation active trouvée.");
        }
        long activeLoans = pretRepository.countByAdherentAndStatutNotIn(adherent, Arrays.asList(Pret.Statut.RETOURNE));
        if (activeLoans >= adherent.getProfil().getQuotaPret()) {
            errors.add("Quota de prêts dépassé.");
        }
        if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
            errors.add("L'exemplaire n'est plus disponible.");
        }
        int age = LocalDate.now().getYear() - adherent.getDateNaissance().getYear();
        if (exemplaire.getLivre().getRestrictionAge() > age) {
            errors.add("L'adhérent ne satisfait pas à la restriction d'âge.");
        }
        if (exemplaire.getLivre().isProfesseurSeulement() && adherent.getProfil().getTypeProfil() != Profil.TypeProfil.PROFESSEUR) {
            errors.add("Livre réservé aux professeurs.");
        }

        if (!errors.isEmpty()) {
            throw new PretException(String.join(" et ", errors));
        }

        // Conversion en prêt
        Pret pret = pretService.preterExemplaire(idAdherent, reservation.getExemplaire().getIdExemplaire(), reservation.getTypePret().name());
        reservation.setStatut(Statut.CONVERTIE_EN_PRET);
        reservationRepository.save(reservation);
        exemplaire.setStatut(Exemplaire.StatutExemplaire.EN_PRET);
        exemplaireRepository.save(exemplaire);
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
        LocalDate currentDate = LocalDate.now();
        return abonnementRepository.findActiveAbonnementByAdherent(adherent, currentDate).isPresent();
    }

    public List<Reservation> findValidatedReservations() {
        return reservationRepository.findByStatut(Statut.VALIDEE);
    }
}

sidebar-adherent :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
    <h3 class="text-center mb-4">Menu Adhérent</h3>
    <a href="/adherent/prets">Voir mes Prêts</a>
    <a href="/adherent/reservations">Voir mes Réservations</a>
    <a href="/adherent/profil">Mon Profil</a>
    <a href="/adherent/reservation">Réserver un Livre</a>
    <a href="/logout" class="btn btn-custom mt-3 ms-3">Déconnexion</a>
</div>

adherentDashboard :
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

reservationForm :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/adherent.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Réserver un Exemplaire</h2>
        <div class="mb-3">
            <input type="text" class="form-control" id="searchBar" placeholder="Rechercher un exemplaire..." onkeyup="filterExemplaires()">
            <input type="number" class="form-control mt-2" id="idFilter" placeholder="Filtrer par ID (optionnel)" onkeyup="filterExemplairesById()">
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
            let idInput = document.getElementById("idFilter").value;
            let cards = document.getElementById("exemplaireCards").getElementsByClassName("card");
            for (let i = 0; i < cards.length; i++) {
                let title = cards[i].getElementsByTagName("h5")[0].innerText.toLowerCase();
                let text = cards[i].innerText.toLowerCase();
                let id = cards[i].getElementsByTagName("h5")[0].innerText.match(/\d+/)[0]; // Extrait l'ID
                if ((text.includes(input) || input === "") && (idInput === "" || id === idInput)) {
                    cards[i].parentElement.style.display = "";
                } else {
                    cards[i].parentElement.style.display = "none";
                }
            }
        }

        function filterExemplairesById() {
            filterExemplaires(); // Réutilise la fonction principale pour éviter la duplication
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