package com.biblio.controller;

import java.time.LocalDate;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.biblio.exception.PretException;
import com.biblio.model.Pret;
import com.biblio.model.Reservation;
import com.biblio.model.User;
import com.biblio.repository.PretRepository;
import com.biblio.repository.ReservationRepository;

import com.biblio.service.PretService;


@Controller
@RequestMapping("/pret")
public class PretController {

    @Autowired
    private PretService pretService;

     @Autowired
    private PretRepository pretRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    

   @GetMapping("/admin/pret")
public String showPretForm(Model model) {
    model.addAttribute("typesPret", new String[]{"DOMICILE", "SUR_PLACE"});
    // model.addAttribute("now", LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
    return "pretForm";
}

@PostMapping("/admin/pret")
public String preterExemplaire(
    @RequestParam("adherentId") Integer adherentId,
    @RequestParam("exemplaireId") Integer exemplaireId,
    @RequestParam("typePret") String typePret,
    @RequestParam(name = "datePret", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate datePret,
    @RequestParam(name = "dateRetourPrevue", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateRetourPrevue,
    Model model) {
    try {
        LocalDate datePretTime = (datePret != null) ? datePret : LocalDate.now();
        LocalDate dateRetourPrevueTime = (dateRetourPrevue != null) ? dateRetourPrevue : null;
        LocalDate datePretDate = datePretTime;
        LocalDate dateRetourPrevueDate = (dateRetourPrevueTime != null) ? dateRetourPrevueTime : null;

        Pret pret = pretService.preterExemplaire(adherentId, exemplaireId, typePret, datePretDate, dateRetourPrevueDate, model);
        if (pret != null) {
            model.addAttribute("message", "Prêt enregistré avec succès. ID du prêt: " + pret.getIdPret());
            model.addAttribute("adjustedDate", pret.getDateRetourPrevue().toString()); // Ajouter la date ajustée au modèle
            model.addAttribute("pret", pret); // Ajouter l'objet prêt au modèle si nécessaire
        }
    } catch (PretException e) {
        model.addAttribute("error", e.getMessage());
    } catch (Exception e) {
        e.printStackTrace();
        model.addAttribute("error", "Une erreur inattendue est survenue.");
    }
    model.addAttribute("typesPret", new String[]{"DOMICILE", "SUR_PLACE"});
    return "pretForm";
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

    /* @GetMapping("/demanderProlongation")
public String showProlongationForm(Model model, HttpSession session) {
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() != User.Role.ADHERENT) {
        return "redirect:/login?role=ADHERENT";
    }
    List<Pret> prets = pretService.findPretsByAdherentId(user.getAdherent().getIdAdherent());
    model.addAttribute("prets", prets);
    model.addAttribute("adherent", user.getAdherent()); // Ajouter l'adhérent au modèle
    return "prolongationForm";
}
 */

@GetMapping("/demanderProlongation")
public String showProlongationForm(Model model, HttpSession session) {
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() != User.Role.ADHERENT) {
        return "redirect:/login?role=ADHERENT";
    }
    List<Pret> prets = pretService.findPretsByAdherentId(user.getAdherent().getIdAdherent());
    System.out.println("Nombre de prêts trouvés : " + prets.size()); // Ajout pour débogage
    model.addAttribute("prets", prets);
    model.addAttribute("adherent", user.getAdherent());
    return "prolongationForm";
}

   /*  @GetMapping("/demanderProlongation")
public String showProlongationForm(Model model, HttpSession session) {
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() != User.Role.ADHERENT) {
        return "redirect:/login?role=ADHERENT";
    }
    List<Pret> prets = pretService.findPretsByAdherentId(user.getAdherent().getIdAdherent());
    model.addAttribute("prets", prets);
    model.addAttribute("adherent", user.getAdherent()); // Ajouter l'adhérent au modèle
    return "prolongationForm";
} */

    @PostMapping("/traiterDemanderProlongation")
public String demanderProlongation(@RequestParam("idPret") int idPret,
                                 @RequestParam("nouvelleDateRetour") String nouvelleDateRetour,
                                 RedirectAttributes redirectAttributes, 
                                 HttpSession session) {
    try {
        LocalDate date = LocalDate.parse(nouvelleDateRetour);
        pretService.demanderProlongation(idPret, date, session);
        redirectAttributes.addFlashAttribute("message", "Demande de prolongation envoyée avec succès.");
    } catch (Exception e) {
        redirectAttributes.addFlashAttribute("error", e.getMessage());
    }
    return "redirect:/pret/mesPrets";
}

   @PostMapping("/admin/convertFinalize")
public String finalizeConvertToPret(
    @RequestParam("idReservation") int idReservation,
    @RequestParam("adherentId") int adherentId,
    @RequestParam("exemplaireId") int exemplaireId,
    @RequestParam("typePret") String typePret,
    @RequestParam(name = "datePret", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate datePret,
    @RequestParam(name = "dateRetourPrevue", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateRetourPrevue,
    Model model,
    RedirectAttributes redirectAttributes) {
    try {
        LocalDate effectiveDatePret = (datePret != null) ? datePret : LocalDate.now();
        LocalDate effectiveDateRetourPrevue = (dateRetourPrevue != null) ? dateRetourPrevue : null;

        Pret pret = pretService.preterExemplaire(adherentId, exemplaireId, typePret, effectiveDatePret, effectiveDateRetourPrevue, model);
        if (pret != null) {
            Reservation reservation = reservationRepository.findById(idReservation)
                    .orElseThrow(() -> new PretException("Réservation non trouvée"));
            reservation.setStatut(Reservation.Statut.CONVERTIE_EN_PRET);
            reservationRepository.save(reservation);
            redirectAttributes.addFlashAttribute("message", "Prêt converti avec succès. ID du prêt: " + pret.getIdPret());
        }
    } catch (PretException e) {
        redirectAttributes.addFlashAttribute("error", e.getMessage());
    }
    return "redirect:/admin/validatedReservations"; // Redirige vers une page sécurisée
}
}
