package com.biblio.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.biblio.exception.PretException;
import com.biblio.service.PretService;

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
            return "pretResult"; // Rediriger vers pretResult.jsp
        } catch (PretException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("typesPret", new String[]{"DOMICILE", "SUR_PLACE"});
            return "pretResult"; // Rediriger vers pretResult.jsp même en cas d'erreur
        }
    }
}