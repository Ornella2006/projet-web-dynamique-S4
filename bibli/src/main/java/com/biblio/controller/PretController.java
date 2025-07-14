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