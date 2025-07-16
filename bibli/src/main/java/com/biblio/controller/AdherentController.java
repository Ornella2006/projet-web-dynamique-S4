package com.biblio.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.biblio.model.Adherent;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ProfilRepository;
import com.biblio.service.AdherentService;

@Controller
public class AdherentController {

    @Autowired
    private AdherentService adherentService;

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private ProfilRepository profilRepository;

    // Liste des adhérents
    @GetMapping("/admin/adherents")
    public String listAdherents(Model model) {
        model.addAttribute("adherents", adherentRepository.findAll());
        model.addAttribute("profils", profilRepository.findAll());
        return "adherentList";
    }

    // Formulaire d'ajout
    @GetMapping("/admin/adherents/add")
    public String showAddAdherentForm(Model model) {
        model.addAttribute("adherent", new Adherent());
        model.addAttribute("profils", profilRepository.findAll());
        return "adherentAdd";
    }

    // Traitement de l'ajout
    @PostMapping("/admin/adherents/add")
    public String addAdherent(@ModelAttribute Adherent adherent) {
        adherentRepository.save(adherent);
        return "redirect:/admin/adherents";
    }

    // Formulaire d'édition
    @GetMapping("/admin/adherents/edit/{id}")
    public String showEditAdherentForm(@PathVariable Integer id, Model model) {
        Adherent adherent = adherentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid adherent Id:" + id));
        model.addAttribute("adherent", adherent);
        model.addAttribute("profils", profilRepository.findAll());
        return "adherentEdit";
    }

    // Traitement de l'édition
    @PostMapping("/admin/adherents/edit/{id}")
    public String updateAdherent(@PathVariable Integer id, @ModelAttribute Adherent adherent) {
        adherent.setIdAdherent(id);
        adherentRepository.save(adherent);
        return "redirect:/admin/adherents";
    }

    // Suppression
    @GetMapping("/admin/adherents/delete/{id}")
    public String deleteAdherent(@PathVariable Integer id) {
        adherentRepository.deleteById(id);
        return "redirect:/admin/adherents";
    }
}