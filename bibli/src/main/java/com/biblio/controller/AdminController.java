package com.biblio.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.biblio.exception.PretException;
import com.biblio.model.Penalite;
import com.biblio.model.Prolongement;
import com.biblio.model.Reservation;
import com.biblio.model.User;
import com.biblio.repository.ReservationRepository;
import com.biblio.repository.ProlongementRepository;

import com.biblio.service.CotisationService;
import com.biblio.service.PenaliteService;
import com.biblio.service.PretService;

import com.biblio.service.ReservationService;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private ProlongementRepository prolongementRepository;

    @Autowired
    private PenaliteService penaliteService;

    @Autowired
    private CotisationService cotisationService;

     @Autowired
    private PretService pretService;

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

    /* @PostMapping("/convertToPret")
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
 */
    @GetMapping("/testExpiration")
    public String testExpiration() {
        Reservation reservation = reservationRepository.findById(1).orElse(null);
        if (reservation != null) {
            reservation.setDateExpiration(LocalDate.now().minusDays(1));
            reservationService.annulerReservationExpiree(reservation);
        }
        return "Test effectué - vérifiez la base de données";
    }

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

    @GetMapping("/prets")
    public String showPrets(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.BIBLIOTHECAIRE) {
            return "redirect:/login?role=BIBLIOTHECAIRE";
        }
        // Logique pour récupérer les prêts si nécessaire
        return "prets";
    }

    @GetMapping("/penalites")
    public String showPenalites(HttpSession session, Model model, @RequestParam(value = "message", required = false) String message,
                            @RequestParam(value = "error", required = false) String error) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.BIBLIOTHECAIRE) {
            return "redirect:/login?role=BIBLIOTHECAIRE";
        }
        // Supposons que vous ayez un service ou repository pour récupérer les pénalités
        // Ici, on utilise un exemple fictif, remplacez par votre logique réelle
        List<Penalite> penalites = penaliteService.findAllPenalites(); // Implémentez cette méthode dans PenaliteService si nécessaire
        model.addAttribute("penalites", penalites);
        if (message != null) model.addAttribute("message", message);
        if (error != null) model.addAttribute("error", error);
        return "penaliteList";
    }

@GetMapping("/convertToPretForm")
public String showConvertToPretForm(@RequestParam("idReservation") int idReservation, Model model, HttpSession session) {
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() != User.Role.BIBLIOTHECAIRE) {
        return "redirect:/login?role=BIBLIOTHECAIRE";
    }
    Reservation reservation = reservationRepository.findById(idReservation)
            .orElseThrow(() -> new PretException("Réservation non trouvée"));
    model.addAttribute("reservation", reservation);
    model.addAttribute("today", LocalDate.now().toString());
    return "convertToPretForm";
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

@GetMapping("/prolongements")
public String showPendingProlongements(HttpSession session, Model model,
                                      @RequestParam(value = "message", required = false) String message,
                                      @RequestParam(value = "error", required = false) String error) {
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() != User.Role.BIBLIOTHECAIRE) {
        return "redirect:/login?role=BIBLIOTHECAIRE";
    }
    List<Prolongement> pendingProlongements = prolongementRepository.findAll().stream()
            .filter(p -> p.getStatut() == Prolongement.StatutProlongement.EN_ATTENTE)
            .collect(Collectors.toList());
    model.addAttribute("prolongements", pendingProlongements);
    if (message != null) model.addAttribute("message", message);
    if (error != null) model.addAttribute("error", error);
    return "pendingProlongements";
}


@PostMapping("/validateProlongement")
public String validateProlongement(@RequestParam("idProlongement") int idProlongement,
                                  RedirectAttributes redirectAttributes) {
    try {
        pretService.validerProlongation(idProlongement);
        redirectAttributes.addFlashAttribute("message", "Prolongement validé avec succès");
    } catch (Exception e) {
        redirectAttributes.addFlashAttribute("error", e.getMessage());
    }
    return "redirect:/admin/prolongements";
}

@PostMapping("/rejectProlongement")
public String rejectProlongement(@RequestParam("idProlongement") int idProlongement,
                                RedirectAttributes redirectAttributes) {
    try {
        pretService.rejeterProlongation(idProlongement);
        redirectAttributes.addFlashAttribute("message", "Prolongement rejeté avec succès");
    } catch (Exception e) {
        redirectAttributes.addFlashAttribute("error", e.getMessage());
    }
    return "redirect:/admin/prolongements";
}


}