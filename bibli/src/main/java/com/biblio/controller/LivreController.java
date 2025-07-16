package com.biblio.controller;

import com.biblio.service.LivreService;
import com.biblio.exception.PretException;
import com.biblio.model.Livre;
import com.biblio.repository.LivreRepository;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.biblio.repository.LivreRepository;

@Controller
public class LivreController {

    @Autowired
    private LivreService livreService;

    @Autowired
    private LivreRepository livreRepository;

    @PostMapping("/definirRestrictions")
    public String definirRestrictions(@RequestParam("idLivre") int idLivre,
                                     @RequestParam(value = "restrictionAge", required = false) Integer restrictionAge,
                                     @RequestParam(value = "professeurSeulement", required = false) Boolean professeurSeulement,
                                     Model model) {
        try {
            livreService.definirRestrictions(idLivre, restrictionAge, professeurSeulement);
            model.addAttribute("message", "Restrictions mises à jour avec succès.");
        } catch (PretException e) {
            model.addAttribute("error", e.getMessage());
        }
        return "redirect:/admin/livres";
    }

    // Dans LivreController.java
    @GetMapping("/admin/livres")
    public String listLivres(Model model) {
        model.addAttribute("livres", livreRepository.findAll());
        return "livreList";
    }

    @GetMapping("/admin/livres/add")
    public String showAddLivreForm(Model model) {
        model.addAttribute("livre", new Livre());
        return "livreForm";
    }

    @PostMapping("/admin/livres/save")
    public String saveLivre(@ModelAttribute Livre livre) {
        livreRepository.save(livre);
        return "redirect:/admin/livres";
    }

    @GetMapping("/admin/livres/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model) {
        model.addAttribute("livre", livreRepository.findById(id).orElseThrow());
        return "livreForm";
    }

    @GetMapping("/admin/livres/delete/{id}")
    public String deleteLivre(@PathVariable Integer id) {
        livreRepository.deleteById(id);
        return "redirect:/admin/livres";
    }
}