package com.biblio.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.biblio.model.Exemplaire;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.LivreRepository;
import com.biblio.service.ExemplaireService;

@Controller
public class ExemplaireController {

    @Autowired
    private ExemplaireService exemplaireService;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private LivreRepository livreRepository;

    // Liste des exemplaires
    @GetMapping("/admin/exemplaires")
    public String listExemplaires(Model model) {
        model.addAttribute("exemplaires", exemplaireRepository.findAllWithLivre());
        return "exemplaireList";
    }

    // Formulaire d'ajout
    @GetMapping("/admin/exemplaires/add")
    public String showAddExemplaireForm(Model model) {
        model.addAttribute("exemplaire", new Exemplaire());
        model.addAttribute("livres", livreRepository.findAll());
        return "exemplaireAdd";
    }

    // Traitement de l'ajout
    @PostMapping("/admin/exemplaires/add")
    public String addExemplaire(@ModelAttribute Exemplaire exemplaire) {
        exemplaireRepository.save(exemplaire);
        return "redirect:/admin/exemplaires";
    }

    // Formulaire d'édition
    @GetMapping("/admin/exemplaires/edit/{id}")
    public String showEditExemplaireForm(@PathVariable Integer id, Model model) {
        Exemplaire exemplaire = exemplaireRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid exemplaire Id:" + id));
        model.addAttribute("exemplaire", exemplaire);
        model.addAttribute("livres", livreRepository.findAll());
        return "exemplaireEdit";
    }

    // Traitement de l'édition
    @PostMapping("/admin/exemplaires/edit/{id}")
    public String updateExemplaire(@PathVariable Integer id, @ModelAttribute Exemplaire exemplaire) {
        exemplaire.setIdExemplaire(id);
        exemplaireRepository.save(exemplaire);
        return "redirect:/admin/exemplaires";
    }

    // Suppression
    @GetMapping("/admin/exemplaires/delete/{id}")
    public String deleteExemplaire(@PathVariable Integer id) {
        exemplaireRepository.deleteById(id);
        return "redirect:/admin/exemplaires";
    }
}