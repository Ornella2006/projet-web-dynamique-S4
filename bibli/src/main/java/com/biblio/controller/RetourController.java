package com.biblio.controller;





import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
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
public String retournerExemplaire(@RequestParam("idPret") Integer idPret,
                                @RequestParam(name = "dateRetour", required = false) 
                                @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateRetour,
                                Model model) {
        try {
            retourService.retournerExemplaire(idPret, dateRetour);
            model.addAttribute("message", "Prêt retourné avec succès. ID du prêt: " + idPret);
        } catch (PretException e) {
            model.addAttribute("error", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Une erreur inattendue est survenue.");
        }
        return "retourForm";
    }


}


