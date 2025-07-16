package com.biblio.controller;

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

import com.biblio.exception.PretException;
import com.biblio.model.Exemplaire;
import com.biblio.model.Reservation;
import com.biblio.model.User;
import com.biblio.repository.*;
import com.biblio.service.*;


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

    @GetMapping("/reservations")
    public String showMyReservations(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.ADHERENT) {
            return "redirect:/login?role=ADHERENT";
        }
        List<Reservation> reservations = reservationRepository.findByStatut(Reservation.Statut.EN_ATTENTE)
                .stream()
                .filter(r -> r.getAdherent().getIdAdherent() == user.getAdherent().getIdAdherent())
                .collect(Collectors.toList());
        model.addAttribute("reservations", reservations);
        return "myReservations"; // Créez une JSP correspondante (myReservations.jsp)
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
}