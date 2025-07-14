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


