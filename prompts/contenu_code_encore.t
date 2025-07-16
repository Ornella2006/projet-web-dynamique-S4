dans controller :
AdminController :
package com.biblio.controller;

import com.biblio.exception.PretException;
import com.biblio.model.Reservation;
import com.biblio.model.User;
import com.biblio.service.PenaliteService;
import com.biblio.repository.ReservationRepository;
import com.biblio.service.ReservationService;
import com.biblio.service.CotisationService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private ReservationRepository reservationRepository;

     @Autowired
    private PenaliteService penaliteService;

    
     @Autowired
    private CotisationService cotisationService;

    

    

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

    @GetMapping("/testExpiration")
public String testExpiration() {
    Reservation reservation = reservationRepository.findById(1).orElse(null);
    if (reservation != null) {
        reservation.setDateExpiration(LocalDateTime.now().minusDays(1)); // Force expiration
        reservationService.annulerReservationExpiree(reservation);
    }
    return "Test effectué - vérifiez la base de données";
}

// Dans AdminController.java
@GetMapping("/expireReservation")
public String expireReservation(@RequestParam("idReservation") int idReservation, 
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
    try {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.BIBLIOTHECAIRE) {
            return "redirect:/login?role=BIBLIOTHECAIRE";
        }
        
        Reservation reservation = reservationRepository.findById(idReservation)
            .orElseThrow(() -> new PretException("Réservation non trouvée"));
        
        // Forcer l'annulation en modifiant la date de retrait prévue
        reservation.setDateRetraitPrevue(LocalDate.now().minusDays(1));
        reservationService.annulerReservationExpiree(reservation);
        
        redirectAttributes.addFlashAttribute("message", "Réservation expirée avec succès");
    } catch (Exception e) {
        redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
    }
    return "redirect:/admin/reservations";
}

@PostMapping("/appliquerPenalite")
public String appliquerPenalite(@RequestParam("idPret") int idPret, Model model) {
    try {
        penaliteService.appliquerPenalite(idPret);
        model.addAttribute("message", "Pénalité appliquée avec succès.");
    } catch (PretException e) {
        model.addAttribute("error", e.getMessage());
    }
    return "redirect:/admin/prets";
}

@PostMapping("/renouvelerCotisation")
public String renouvelerCotisation(@RequestParam("idAdherent") int idAdherent,
                                  @RequestParam("dateDebut") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
                                  @RequestParam("dateFin") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
                                  @RequestParam("montant") BigDecimal montant, Model model) {
    try {
        cotisationService.renouvelerCotisation(idAdherent, dateDebut, dateFin, montant);
        model.addAttribute("message", "Cotisation renouvelée avec succès.");
    } catch (PretException e) {
        model.addAttribute("error", e.getMessage());
    }
    return "redirect:/admin/cotisations";
}
}

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

CotisationController :
package com.biblio.controller;

import com.biblio.service.CotisationService;
import com.biblio.exception.PretException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.time.LocalDate;

@Controller
public class CotisationController {

    @Autowired
    private CotisationService cotisationService;

    @PostMapping("/renouvelerCotisation")
    public String renouvelerCotisation(@RequestParam("idAdherent") int idAdherent,
                                      @RequestParam("dateDebut") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
                                      @RequestParam("dateFin") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
                                      @RequestParam("montant") BigDecimal montant, Model model) {
        try {
            cotisationService.renouvelerCotisation(idAdherent, dateDebut, dateFin, montant);
            model.addAttribute("message", "Cotisation renouvelée avec succès.");
        } catch (PretException e) {
            model.addAttribute("error", e.getMessage());
        }
        return "redirect:/admin/cotisations";
    }
}

LivreController :
package com.biblio.controller;

import com.biblio.service.LivreService;
import com.biblio.exception.PretException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LivreController {

    @Autowired
    private LivreService livreService;

    @PostMapping("/definirRestrictions")
    public String definirRestrictions(@RequestParam("idLivre") int idLivre,
                                     @RequestParam(value = "restrictionAge", required = false) Integer restrictionAge,
                                     @RequestParam(value = "professeurSeulement", required = false) Boolean professeurSeulement,
                                     Model model) {
        try {
            livreService.definirRestrictions(idLivre, restrictionAge, professeurSeulement);
            model.addAttribute("message", "Restrictions mises à jour avec succès.");
        } catch (PretException e) {
            model.addAttribute("error", e.getMessage());
        }
        return "redirect:/admin/livres";
    }
}

PenaliteController :
package com.biblio.controller;

import com.biblio.service.PenaliteService;
import com.biblio.exception.PretException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PenaliteController {

    @Autowired
    private PenaliteService penaliteService;

    @PostMapping("/appliquerPenalite")
    public String appliquerPenalite(@RequestParam("idPret") int idPret, Model model) {
        try {
            penaliteService.appliquerPenalite(idPret);
            model.addAttribute("message", "Pénalité appliquée avec succès.");
        } catch (PretException e) {
            model.addAttribute("error", e.getMessage());
        }
        return "redirect:/admin/prets";
    }
}

PretController :
package com.biblio.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.biblio.exception.PretException;
import com.biblio.model.Pret;
import com.biblio.model.User;
import com.biblio.service.PretService;

@Controller
@RequestMapping("/pret")
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

    @GetMapping("/mesPrets")
    public String mesPrets(Model model, HttpSession session) {
        com.biblio.model.User user = (com.biblio.model.User) session.getAttribute("user");
        if (user == null || user.getRole() != com.biblio.model.User.Role.ADHERENT) {
            return "redirect:/login?role=ADHERENT";
        }
        List<Pret> prets = pretService.findPretsByAdherentId(user.getAdherent().getIdAdherent());
        model.addAttribute("prets", prets);
        model.addAttribute("adherent", user.getAdherent()); // Pour accéder au quota
        return "mesPrets";
    }

    @PostMapping("/demanderProlongation")
    public String demanderProlongation(@RequestParam("idPret") int idPret,
                                      @RequestParam("nouvelleDateRetour") String nouvelleDateRetour,
                                      Model model, HttpSession session) {
        try {
            LocalDateTime date = LocalDateTime.parse(nouvelleDateRetour); // Ajuster selon votre format d'entrée
            pretService.demanderProlongation(idPret, date, session);
            model.addAttribute("message", "Demande de prolongation envoyée avec succès.");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        return "redirect:/pret/mesPrets";
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
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
public String processReservation(@RequestParam("exemplaireId") Integer exemplaireId,
                                @RequestParam("typePret") String typePret,
                                @RequestParam("dateRetraitPrevue") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateRetraitPrevue,
                                HttpSession session, Model model) {
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() != User.Role.ADHERENT) {
        return "redirect:/login?role=ADHERENT";
    }
    try {
        if (exemplaireId == null) {
            throw new PretException("Veuillez sélectionner ou entrer un ID d'exemplaire valide.");
        }
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

TestController :

dans Exception
PretException :

dans model :
Abonnement.java :
package com.biblio.model;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "Abonnement")
public class Abonnement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_abonnement")
    private int idAbonnement;

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
    @Column(name = "statut", nullable = false)
    private Statut statut;

    public enum Statut {
        ACTIVE, EXPIREE
    }

    // Constructeurs, Getters, Setters
    public Abonnement() {}

    public Abonnement(Adherent adherent, LocalDate dateDebut, LocalDate dateFin, double montant, Statut statut) {
        this.adherent = adherent;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
        this.montant = montant;
        this.statut = statut;
    }

    public int getIdAbonnement() { return idAbonnement; }
    public void setIdAbonnement(int idAbonnement) { this.idAbonnement = idAbonnement; }
    public Adherent getAdherent() { return adherent; }
    public void setAdherent(Adherent adherent) { this.adherent = adherent; }
    public LocalDate getDateDebut() { return dateDebut; }
    public void setDateDebut(LocalDate dateDebut) { this.dateDebut = dateDebut; }
    public LocalDate getDateFin() { return dateFin; }
    public void setDateFin(LocalDate dateFin) { this.dateFin = dateFin; }
    public double getMontant() { return montant; }
    public void setMontant(double montant2) { this.montant = montant2; }
    public Statut getStatut() { return statut; }
    public void setStatut(Statut statut) { this.statut = statut; }
}

Adherent.java :
package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

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

    @Column(name = "date_fin_sanction")
    private LocalDateTime dateFinSanction;

    @OneToMany(mappedBy = "adherent")
    private List<Abonnement> abonnements;

    public Integer getQuotaRestant() {
        return quotaRestant;
    }

    public void setQuotaRestant(Integer quotaRestant) {
        this.quotaRestant = quotaRestant;
    }

    public boolean isCotisationActive() {
        if (abonnements == null || abonnements.isEmpty()) return false;
        return abonnements.stream()
                .filter(a -> a.getStatut() == Abonnement.Statut.ACTIVE)
                .anyMatch(a -> LocalDate.now().isBefore(a.getDateFin()) && LocalDate.now().isAfter(a.getDateDebut()));
    }

    public boolean isSanctionne() {
        return this.statut == StatutAdherent.SANCTIONNE;
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

    public LocalDateTime getDateFinSanction() {
        return dateFinSanction;
    }

    public void setDateFinSanction(LocalDateTime dateFinSanction) {
        this.dateFinSanction = dateFinSanction;
    }

    public List<Abonnement> getAbonnements() { return abonnements; }
    public void setAbonnements(List<Abonnement> abonnements) { this.abonnements = abonnements; }
}

Cotisation.java :

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

Livre.java :
package com.biblio.model;

import javax.persistence.*;
import java.time.Year;

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

    @Column(name = "annee_publication")
    private Year anneePublication;

    private String genre;

    @Column(unique = true)
    private String isbn;

    @Column(name = "restriction_age", nullable = false)
    private int restrictionAge = 0;

    @Column(name = "professeur_seulement", nullable = false)
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
    public Year getAnneePublication() { return anneePublication; }
    public void setAnneePublication(Year anneePublication) { this.anneePublication = anneePublication; }
    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public int getRestrictionAge() { return restrictionAge; }
    public void setRestrictionAge(int restrictionAge) { this.restrictionAge = restrictionAge; }
    public boolean isProfesseurSeulement() { return professeurSeulement; }
    public void setProfesseurSeulement(boolean professeurSeulement) { this.professeurSeulement = professeurSeulement; }
}

Penalite.java :
package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "Penalite")
public class Penalite {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_penalite")
    private int idPenalite;

    @ManyToOne
    @JoinColumn(name = "id_adherent", nullable = false)
    private Adherent adherent;

    @ManyToOne
    @JoinColumn(name = "id_pret")
    private Pret pret;

    @Column(name = "date_debut_penalite", nullable = false)
    private LocalDate dateDebutPenalite;

    @Column(name = "date_fin_penalite", nullable = false)
    private LocalDate dateFinPenalite;

    @Column(name = "raison")
    private String raison;

    // Constructeurs
    public Penalite() {}

    public Penalite(Adherent adherent, Pret pret, LocalDate dateDebutPenalite, LocalDate dateFinPenalite, String raison) {
        this.adherent = adherent;
        this.pret = pret;
        this.dateDebutPenalite = dateDebutPenalite;
        this.dateFinPenalite = dateFinPenalite;
        this.raison = raison;
    }

    // Getters et Setters
    public int getIdPenalite() { return idPenalite; }
    public void setIdPenalite(int idPenalite) { this.idPenalite = idPenalite; }
    public Adherent getAdherent() { return adherent; }
    public void setAdherent(Adherent adherent) { this.adherent = adherent; }
    public Pret getPret() { return pret; }
    public void setPret(Pret pret) { this.pret = pret; }
    public LocalDate getDateDebutPenalite() { return dateDebutPenalite; }
    public void setDateDebutPenalite(LocalDate dateDebutPenalite) { this.dateDebutPenalite = dateDebutPenalite; }
    public LocalDate getDateFinPenalite() { return dateFinPenalite; }
    public void setDateFinPenalite(LocalDate dateFinPenalite) { this.dateFinPenalite = dateFinPenalite; }
    public String getRaison() { return raison; }
    public void setRaison(String raison) { this.raison = raison; }
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

Prolongement.java :
package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Prolongement")
public class Prolongement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_prolongement")
    private int idProlongement;

    @ManyToOne
    @JoinColumn(name = "id_pret", nullable = false)
    private Pret pret;

    @Column(name = "date_demande_prolongement", nullable = false)
    private LocalDateTime dateDemandeProlongement;

    @Column(name = "nouvelle_date_retour", nullable = false)
    private LocalDateTime nouvelleDateRetour;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut", nullable = false)
    private StatutProlongement statut;

    @ManyToOne
    @JoinColumn(name = "id_adherent", nullable = false)
    private Adherent adherent;

    public enum StatutProlongement {
        EN_ATTENTE, VALIDE, REFUSE
    }

    // Constructeurs
    public Prolongement() {}

    public Prolongement(Pret pret, LocalDateTime dateDemandeProlongement, LocalDateTime nouvelleDateRetour, Adherent adherent) {
        this.pret = pret;
        this.dateDemandeProlongement = dateDemandeProlongement;
        this.nouvelleDateRetour = nouvelleDateRetour;
        this.adherent = adherent;
        this.statut = StatutProlongement.EN_ATTENTE;
    }

    // Getters et Setters
    public int getIdProlongement() { return idProlongement; }
    public void setIdProlongement(int idProlongement) { this.idProlongement = idProlongement; }
    public Pret getPret() { return pret; }
    public void setPret(Pret pret) { this.pret = pret; }
    public LocalDateTime getDateDemandeProlongement() { return dateDemandeProlongement; }
    public void setDateDemandeProlongement(LocalDateTime dateDemandeProlongement) { this.dateDemandeProlongement = dateDemandeProlongement; }
    public LocalDateTime getNouvelleDateRetour() { return nouvelleDateRetour; }
    public void setNouvelleDateRetour(LocalDateTime nouvelleDateRetour) { this.nouvelleDateRetour = nouvelleDateRetour; }
    public StatutProlongement getStatut() { return statut; }
    public void setStatut(StatutProlongement statut) { this.statut = statut; }
    public Adherent getAdherent() { return adherent; }
    public void setAdherent(Adherent adherent) { this.adherent = adherent; }
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

   User.java :

dans repository :
AbonnementRepository.java :
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

    @Query("SELECT COUNT(a) > 0 FROM Abonnement a WHERE a.adherent = :adherent AND a.dateFin > :currentDate")
    boolean existsByAdherentAndDateFinAfter(@Param("adherent") Adherent adherent, @Param("currentDate") LocalDate currentDate);

    // @Query("SELECT a FROM Abonnement a WHERE a.adherent = :adherent AND a.statut = 'ACTIVE' AND :date BETWEEN a.dateDebut AND a.dateFin")
    // Optional<Abonnement> findActiveAbonnementByAdherent(@Param("adherent") Adherent adherent, @Param("date") LocalDate date);
}

AdherentRepository.java :
package com.biblio.repository;

import com.biblio.model.Adherent;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdherentRepository extends JpaRepository<Adherent, Integer> {
}


CotisationRepository.java :
package com.biblio.repository;

public class CotisationRepository {
    
}

ExemplaireRepository.java :
package com.biblio.repository;

import com.biblio.model.Exemplaire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ExemplaireRepository extends JpaRepository<Exemplaire, Integer> {
    @Query("SELECT e FROM Exemplaire e JOIN FETCH e.livre")
    List<Exemplaire> findAllWithLivre();
}



JourFerieRepository.java :
package com.biblio.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.biblio.model.JourFerie;

public interface JourFerieRepository extends JpaRepository<JourFerie, Integer> {
    List<JourFerie> findByDateFerieBetween(LocalDate startDate, LocalDate endDate);
}

LivreRepository.java :
package com.biblio.repository;

import com.biblio.model.Livre;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LivreRepository extends JpaRepository<Livre, Integer> {
}

PenaliteRepository.java :
package com.biblio.repository;

import com.biblio.model.Adherent;
import com.biblio.model.Penalite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface PenaliteRepository extends JpaRepository<Penalite, Integer> {
    @Query("SELECT p FROM Penalite p WHERE p.adherent = :adherent AND p.dateFin > :date")
    List<Penalite> findByAdherentAndDateFinAfter(@Param("adherent") Adherent adherent, @Param("date") LocalDateTime date);
}

PretRepository.java :
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


ProlongementRepository.java :
package com.biblio.repository;

import com.biblio.model.Adherent;
import com.biblio.model.Prolongement;
import com.biblio.model.Prolongement.StatutProlongement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProlongementRepository extends JpaRepository<Prolongement, Integer> {
    @Query("SELECT COUNT(p) FROM Prolongement p WHERE p.adherent = :adherent AND p.statut = :statut")
    long countByAdherentAndStatut(@Param("adherent") Adherent adherent, @Param("statut") StatutProlongement statut);
}

ReservationRepository.java :
package com.biblio.repository;

import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
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

    @Query("SELECT CASE WHEN COUNT(r) > 0 THEN true ELSE false END FROM Reservation r WHERE r.exemplaire = :exemplaire AND r.statut = :statut")
    boolean existsByExemplaireAndStatut(@Param("exemplaire") Exemplaire exemplaire, @Param("statut") Statut statut);
}

UserRepository.java :
package com.biblio.repository;

import com.biblio.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Integer> {
    User findByEmail(String email);
}

dans scheduler 
ReservationExpirationScheduler.java :
package com.biblio.scheduler;

import com.biblio.model.Reservation;
import com.biblio.repository.ReservationRepository;
import com.biblio.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class ReservationExpirationScheduler {

    @Autowired
    private ReservationRepository reservationRepository;
    
    @Autowired
    private ReservationService reservationService;

    // Exécuté tous les jours à minuit
    @Scheduled(cron = "0 0 0 * * ?")
    public void checkExpiredReservations() {
        List<Reservation> pendingReservations = reservationRepository.findByStatut(Reservation.Statut.EN_ATTENTE);
        
        for (Reservation reservation : pendingReservations) {
            reservationService.annulerReservationExpiree(reservation);
        }
    }
}

dans service :
AbonnementService.java :
package com.biblio.service;

import com.biblio.exception.PretException;
import com.biblio.model.Abonnement;
import com.biblio.model.Adherent;
import com.biblio.repository.AbonnementRepository;
import com.biblio.repository.AdherentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

@Service
public class AbonnementService {

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private AdherentRepository adherentRepository;

    @Transactional
    public Abonnement renouvelerAbonnement(int idAdherent, LocalDate debut, LocalDate fin, double montant) throws PretException {
        System.out.println("Début renouvelerAbonnement: idAdherent=" + idAdherent + ", debut=" + debut + ", fin=" + fin);

        // Valider l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));

        // Vérifier s'il existe une cotisation active
        if (abonnementRepository.existsByAdherentAndDateFinAfter(adherent, LocalDate.now())) {
            throw new PretException("Une cotisation active existe déjà.");
        }

        // Créer l'abonnement
        Abonnement abonnement = new Abonnement();
        abonnement.setAdherent(adherent);
        abonnement.setDateDebut(debut);
        abonnement.setDateFin(fin);
        abonnement.setMontant(montant);
        abonnement.setStatut(Abonnement.Statut.ACTIVE);

        // Réinitialiser le quota restant
        adherent.setQuotaRestant(adherent.getProfil().getQuotaPret());
        adherentRepository.save(adherent);

        // Enregistrer l'abonnement
        try {
            abonnementRepository.save(abonnement);
            System.out.println("Abonnement renouvelé: " + abonnement.getIdAbonnement() + ", Quota restant réinitialisé: " + adherent.getQuotaRestant());
            return abonnement;
        } catch (Exception e) {
            e.printStackTrace();
            throw new PretException("Erreur lors du renouvellement de l'abonnement: " + e.getMessage());
        }
    }
}

CotisationService.java :
package com.biblio.service;

import com.biblio.exception.PretException;
import com.biblio.model.Adherent;
import com.biblio.model.Abonnement;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.AbonnementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;

@Service
public class CotisationService {

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Transactional
    public void renouvelerCotisation(int idAdherent, LocalDate debut, LocalDate fin, BigDecimal montant) throws PretException {
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("Adhérent inexistant."));

        if (abonnementRepository.existsByAdherentAndDateFinAfter(adherent, LocalDate.now())) {
            throw new PretException("Une cotisation active existe déjà.");
        }

        Abonnement cotisation = new Abonnement();
        cotisation.setAdherent(adherent);
        cotisation.setDateDebut(debut);
        cotisation.setDateFin(fin);
        cotisation.setMontant(montant.doubleValue()); // Conversion BigDecimal en double
        cotisation.setStatut(Abonnement.Statut.ACTIVE);
        abonnementRepository.save(cotisation);

        // Pas de setCotisationActive, la logique est gérée par isCotisationActive()
    }
}

LivreService.java :
package com.biblio.service;

import com.biblio.exception.PretException;
import com.biblio.model.Livre;
import com.biblio.repository.LivreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LivreService {

    @Autowired
    private LivreRepository livreRepository;

    @Transactional
    public void definirRestrictions(int idLivre, Integer restrictionAge, Boolean professeurSeulement) throws PretException {
        Livre livre = livreRepository.findById(idLivre)
                .orElseThrow(() -> new PretException("Livre inexistant."));
        
        if (restrictionAge != null && restrictionAge < 0) {
            throw new PretException("L'âge minimum doit être non négatif.");
        }

        livre.setRestrictionAge(restrictionAge != null ? restrictionAge : 0); // Valeur par défaut 0 si null
        livre.setProfesseurSeulement(professeurSeulement != null ? professeurSeulement : false); // Valeur par défaut false si null
        livreRepository.save(livre);
    }
}

PenaliteService.java :
package com.biblio.service;

import com.biblio.exception.PretException;
import com.biblio.model.Adherent;
import com.biblio.model.Penalite;
import com.biblio.model.Pret;
import com.biblio.model.JourFerie;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.PenaliteRepository;
import com.biblio.repository.PretRepository;
import com.biblio.repository.JourFerieRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class PenaliteService {

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private PenaliteRepository penaliteRepository;

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private JourFerieRepository jourFerieRepository;

    @Transactional
    public void appliquerPenalite(int idPret) throws PretException {
        // Récupérer le prêt
        Pret pret = pretRepository.findById(idPret)
                .orElseThrow(() -> new PretException("Prêt inexistant."));

        // Vérifier s'il y a un retard
        if (pret.getDateRetourEffective() == null || !pret.getDateRetourEffective().isAfter(pret.getDateRetourPrevue())) {
            return; // Pas de retard
        }

        Adherent adherent = pret.getAdherent();
        if (adherent == null) {
            throw new PretException("Adhérent inexistant pour ce prêt.");
        }

        // Calculer la durée de la pénalité basée sur le profil
        int dureePenalite = adherent.getProfil().getDureePenalite();

        // Convertir la date de retour effective en LocalDate pour correspondre à la table
        LocalDate dateDebutPenalite = pret.getDateRetourEffective().toLocalDate();
        LocalDate dateFinPenalite = ajusterPourJoursFeries(dateDebutPenalite.plusDays(dureePenalite));

        // Vérifier les pénalités existantes pour cumuler si nécessaire
        List<Penalite> penalitesExistantes = penaliteRepository.findByAdherentAndDateFinAfter(adherent, LocalDateTime.now());
        LocalDate nouvelleDateFinPenalite = dateFinPenalite;
        if (!penalitesExistantes.isEmpty()) {
            Penalite dernierePenalite = penalitesExistantes.get(penalitesExistantes.size() - 1);
            nouvelleDateFinPenalite = dernierePenalite.getDateFinPenalite().plusDays(dureePenalite);
            nouvelleDateFinPenalite = ajusterPourJoursFeries(nouvelleDateFinPenalite);
        }

        // Créer et sauvegarder la pénalité
        Penalite penalite = new Penalite();
        penalite.setAdherent(adherent);
        penalite.setPret(pret);
        penalite.setDateDebutPenalite(dateDebutPenalite);
        penalite.setDateFinPenalite(nouvelleDateFinPenalite);
        penalite.setRaison("Retard de retour du prêt ID: " + idPret);
        penaliteRepository.save(penalite);

        // Mettre à jour le statut de l'adhérent
        adherent.setStatut(Adherent.StatutAdherent.SANCTIONNE);
        adherent.setDateFinSanction(nouvelleDateFinPenalite.atStartOfDay());
        adherentRepository.save(adherent);
    }

    private LocalDate ajusterPourJoursFeries(LocalDate date) {
        List<JourFerie> joursFeries = jourFerieRepository.findAll();
        LocalDate dateAjustee = date;
        boolean ajustementNecessaire;

        do {
            ajustementNecessaire = false;
            for (JourFerie jourFerie : joursFeries) {
                if (jourFerie.getDateFerie().equals(dateAjustee)) {
                    ajustementNecessaire = true;
                    if (jourFerie.getRegleRendu() == JourFerie.RegleRendu.AVANT) {
                        dateAjustee = dateAjustee.minusDays(1);
                    } else {
                        dateAjustee = dateAjustee.plusDays(1);
                    }
                    break;
                }
            }
        } while (ajustementNecessaire);

        return dateAjustee;
    }
}

PretService.java :
package com.biblio.service;

import com.biblio.exception.PretException;
import com.biblio.model.*;
import com.biblio.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpSession;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class PretService {

    @Autowired
    private PretRepository pretRepository;
    @Autowired
    private ProlongementRepository prolongementRepository;
    @Autowired
    private AdherentRepository adherentRepository;
    @Autowired
    private ExemplaireRepository exemplaireRepository;
    @Autowired
    private JourFerieRepository jourFerieRepository;
    @Autowired
    private AbonnementRepository abonnementRepository;
    @Autowired
    private ReservationRepository reservationRepository;

    @Value("${prolongation.jours_avance:2}") // Configurable via application.properties
    private int joursAvanceMin;

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

    @Value("${prolongation.max_parallele:2}") // Maximum de prolongements parallèles
    private int maxProlongementsParalleles;

    @Transactional
    public Prolongement demanderProlongation(int idPret, LocalDateTime nouvelleDateRetour, HttpSession session) throws PretException {
        com.biblio.model.User user = (com.biblio.model.User) session.getAttribute("user");
        if (user == null || user.getRole() != com.biblio.model.User.Role.ADHERENT) {
            throw new PretException("Utilisateur non connecté ou non autorisé.");
        }

        Pret pret = pretRepository.findById(idPret)
                .orElseThrow(() -> new PretException("Prêt inexistant."));
        
        Adherent adherent = pret.getAdherent();
        if (!adherent.isCotisationActive()) {
            throw new PretException("Cotisation inactive.");
        }
        if (adherent.isSanctionne()) {
            throw new PretException("Adhérent sous sanction jusqu'à la fin de la pénalité.");
        }
        if (pret.getDateRetourEffective() != null) {
            throw new PretException("Prêt déjà retourné.");
        }
        long prolongementsEnCours = prolongementRepository.countByAdherentAndStatut(adherent, Prolongement.StatutProlongement.EN_ATTENTE);
        if (prolongementsEnCours >= maxProlongementsParalleles) {
            throw new PretException("Quota de prolongements parallèles (" + maxProlongementsParalleles + ") dépassé.");
        }
        if (pret.getProlongationCount() >= adherent.getProfil().getQuotaProlongement()) {
            throw new PretException("Quota de prolongements total dépassé.");
        }
        LocalDateTime dateLimite = pret.getDateRetourPrevue().minusDays(joursAvanceMin);
        if (LocalDateTime.now().isAfter(dateLimite)) {
            throw new PretException("Demande trop tardive, " + joursAvanceMin + " jours d'avance requis.");
        }
        if (reservationRepository.existsByExemplaireAndStatut(pret.getExemplaire(), Reservation.Statut.VALIDEE)) {
            throw new PretException("Impossible de prolonger, exemplaire réservé.");
        }

        LocalDateTime dateAjustee = ajusterPourJoursFeries(nouvelleDateRetour);
        Prolongement prolongement = new Prolongement(pret, LocalDateTime.now(), dateAjustee, adherent);
        return prolongementRepository.save(prolongement);
    }

    @Transactional
    public void validerProlongation(int idProlongement) throws PretException {
        Prolongement prolongement = prolongementRepository.findById(idProlongement)
                .orElseThrow(() -> new PretException("Prolongement inexistant."));
        if (prolongement.getStatut() != Prolongement.StatutProlongement.EN_ATTENTE) {
            throw new PretException("Prolongement déjà traité.");
        }

        Pret pret = prolongement.getPret();
        pret.setDateRetourPrevue(prolongement.getNouvelleDateRetour());
        pret.setProlongationCount(pret.getProlongationCount() + 1);
        prolongement.setStatut(Prolongement.StatutProlongement.VALIDE);
        pretRepository.save(pret);
        prolongementRepository.save(prolongement);
    }

    @Transactional
    public void rejeterProlongation(int idProlongement) throws PretException {
        Prolongement prolongement = prolongementRepository.findById(idProlongement)
                .orElseThrow(() -> new PretException("Prolongement inexistant."));
        if (prolongement.getStatut() != Prolongement.StatutProlongement.EN_ATTENTE) {
            throw new PretException("Prolongement déjà traité.");
        }
        prolongement.setStatut(Prolongement.StatutProlongement.REFUSE);
        prolongementRepository.save(prolongement);
    }

    private LocalDateTime ajusterPourJoursFeries(LocalDateTime date) {
        List<JourFerie> joursFeries = jourFerieRepository.findAll();
        LocalDateTime dateAjustee = date; // Copie initiale
        boolean ajustementNecessaire;

        do {
            ajustementNecessaire = false;
            for (JourFerie jourFerie : joursFeries) {
                if (jourFerie.getDateFerie().equals(dateAjustee.toLocalDate())) {
                    ajustementNecessaire = true;
                    if (jourFerie.getRegleRendu() == JourFerie.RegleRendu.AVANT) {
                        dateAjustee = dateAjustee.minusDays(1);
                    } else {
                        dateAjustee = dateAjustee.plusDays(1);
                    }
                    break; // Sortir de la boucle pour réévaluer
                }
            }
        } while (ajustementNecessaire);

        return dateAjustee;
    }

    public List<Pret> findPretsByAdherentId(int idAdherent) {
        return pretRepository.findAll().stream()
                .filter(p -> p.getAdherent().getIdAdherent() == idAdherent)
                .toList();
    }
}

ReservationService.java :
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
        // Initialiser quotaRestant s'il est null
        if (adherent.getQuotaRestant() == null) {
            adherent.setQuotaRestant(adherent.getProfil().getQuotaReservation()); // Initialiser avec le quota par défaut
            adherentRepository.save(adherent);
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

    // Vérifications supplémentaires
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
        adherent.setQuotaRestant(adherent.getQuotaRestant() - 1); // Utilisation sécurisée après initialisation
        adherentRepository.save(adherent);
        return reservationRepository.save(reservation);
    }
    return null;
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
    System.out.println("=== Début annulerReservationExpiree ===");
    System.out.println("Statut actuel: " + reservation.getStatut());
    System.out.println("Date expiration: " + reservation.getDateExpiration());
    System.out.println("Date maintenant: " + LocalDateTime.now());
    System.out.println("Date retrait prévue: " + reservation.getDateRetraitPrevue());
    
    // Vérifie si la date de retrait prévue est passée ET si le statut est EN_ATTENTE
    if (reservation.getStatut() == Statut.EN_ATTENTE && 
        LocalDate.now().isAfter(reservation.getDateRetraitPrevue())) {
        
        System.out.println("Condition vérifiée - annulation en cours");
        
        reservation.setStatut(Statut.EXPIREE);
        reservation.setDateExpiration(LocalDateTime.now()); // Marquer comme expiré maintenant
        
        // Rendre l'exemplaire disponible
        Exemplaire exemplaire = reservation.getExemplaire();
        exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);
        
        // Restaurer le quota de l'adhérent
        Adherent adherent = reservation.getAdherent();
        adherent.setQuotaRestant(adherent.getQuotaRestant() + 1);
        
        // Sauvegarder les modifications
        reservationRepository.save(reservation);
        exemplaireRepository.save(exemplaire);
        adherentRepository.save(adherent);
        
        System.out.println("Annulation effectuée avec succès");
    } else {
        System.out.println("Condition NON vérifiée - Pas d'annulation");
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

RetourService.java :
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

dans src/main/java/com/biblio/  :
Application.java :
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

dans resources :
application.properties :
     spring.datasource.url=jdbc:mysql://localhost:3306/gestion_bibliotheque?useSSL=false&serverTimezone=UTC
     spring.datasource.username=root
     spring.datasource.password=
     spring.jpa.hibernate.ddl-auto=update
     spring.jpa.show-sql=true
     spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
     spring.mvc.view.prefix=/WEB-INF/views/
     spring.mvc.view.suffix=.jsp
     server.port=8081
     spring.jpa.open-in-view=false
     logging.level.org.hibernate.SQL=DEBUG
     logging.level.org.hibernate.type.descriptor.sql=TRACE

     dans webapp/css :
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
public.css :

dans web-inf/views/fragments/
sidebar-admin.jsp :
sidebar-adherent.jsp :

dans web-ing/views/ :
adherentDashboard.jsp :
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

adminReservations.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Réservations en attente</h2>
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
                            <form action="/admin/validateReservation" method="post" style="display:inline;">
                                <input type="hidden" name="idReservation" value="${reservation.idReservation}">
                                <button type="submit" class="btn btn-custom btn-sm">Valider</button>
                            </form>
                            <form action="/admin/rejectReservation" method="post" style="display:inline;">
                                <input type="hidden" name="idReservation" value="${reservation.idReservation}">
                                <button type="submit" class="btn btn-custom btn-sm" style="background-color: #A0522D;">Rejeter</button>
                            </form>
                            <form action="/admin/convertToPret" method="post" style="display:inline;">
                                <input type="hidden" name="idReservation" value="${reservation.idReservation}">
                                <input type="number" name="idAdherent" value="${reservation.adherent.idAdherent}" required style="display:none;">
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

choice.jsp :

login.jsp :

mesPrets.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/adherent.css" rel="stylesheet">

<table>
    <thead>
        <tr>
            <th>ID Prêt</th>
            <th>Titre</th>
            <th>Date de Retour Prévue</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="pret" items="${prets}">
            <tr>
                <td>${pret.idPret}</td>
                <td>${pret.exemplaire.livre.titre}</td>
                <td>${pret.dateRetourPrevue}</td>
                <c:if test="${pret.prolongationCount < adherent.profil.quotaProlongement and adherent.quotaRestant > 0}">
                    <form action="/pret/demanderProlongation" method="post" style="display:inline;">
                        <input type="hidden" name="idPret" value="${pret.idPret}">
                        <input type="datetime-local" name="nouvelleDateRetour" required>
                        <button type="submit" class="btn btn-custom btn-sm">Prolonger</button>
                    </form>
                </c:if>
                <c:if test="${pret.prolongationCount >= adherent.profil.quotaProlongement or adherent.quotaRestant <= 0}">
                    <span class="text-danger">Prolongation non disponible</span>
                </c:if>
            </tr>
        </c:forEach>
    </tbody>
</table>

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
        <form id="reservationForm" action="/adherent/reservation" method="post" class="mt-4" onsubmit="return validateForm()">
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
        let selectedId = null;

        document.querySelectorAll('.select-btn').forEach(button => {
            button.addEventListener('click', function() {
                selectedId = this.getAttribute('data-id');
                document.getElementById('exemplaireId').value = selectedId;
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
                let id = cards[i].getElementsByTagName("h5")[0].innerText.match(/\d+/)[0];
                if ((text.includes(input) || input === "") && (idInput === "" || id === idInput)) {
                    cards[i].parentElement.style.display = "";
                } else {
                    cards[i].parentElement.style.display = "none";
                }
            }
        }

        function filterExemplairesById() {
            let idInput = document.getElementById("idFilter").value;
            if (idInput && !selectedId) { // Mettre à jour exemplaireId uniquement si aucune carte n'est sélectionnée
                document.getElementById('exemplaireId').value = idInput;
            }
            filterExemplaires();
        }

        function validateForm() {
            if (!document.getElementById('exemplaireId').value) {
                alert("Veuillez sélectionner un exemplaire ou entrer un ID valide.");
                return false;
            }
            return true;
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

validatedResevations.jsp :
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

PretServiceTest.java dans src/test/java/com/biblio/service :
je l'ai configurer en skip dans pom.xml

base.sql :
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
    statut ENUM('EN_COURS', 'RETOURNE') NOT NULL DEFAULT 'EN_COURS',
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
    type_pret ENUM('DOMICILE', 'SUR_PLACE') NOT NULL DEFAULT 'DOMICILE',
    statut ENUM('EN_ATTENTE', 'VALIDEE', 'ANNULEE', 'EXPIREE', 'CONVERTIE_EN_PRET') DEFAULT 'EN_ATTENTE',
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



UPDATE Adherent SET statut = 'ACTIF' WHERE id_adherent = 1;
UPDATE Abonnement SET statut = 'ACTIVE' WHERE id_adherent = 1;