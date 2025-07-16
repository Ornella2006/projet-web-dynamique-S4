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