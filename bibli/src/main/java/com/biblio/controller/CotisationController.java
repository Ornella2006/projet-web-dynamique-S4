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