package com.biblio.controller;

import com.biblio.exception.BibliothequeException;
import com.biblio.model.Pret;
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
    public String showPretForm() {
        return "pret"; // Nom de la vue JSP
    }

    @PostMapping("/pret")
    public String preterLivre(@RequestParam Long adherentId, @RequestParam Long exemplaireId,
                              @RequestParam String typePret, Model model) {
        try {
            Pret pret = pretService.preterLivre(adherentId, exemplaireId, typePret);
            model.addAttribute("message", "Prêt effectué avec succès !");
            return "pret";
        } catch (BibliothequeException e) {
            model.addAttribute("error", e.getMessage());
            return "index"; // Redirection vers la page d'accueil avec erreur
        }
    }
}