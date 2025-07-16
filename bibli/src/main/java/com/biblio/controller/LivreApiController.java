package com.biblio.controller;

import com.biblio.model.Exemplaire;
import com.biblio.model.Livre;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.LivreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/livres")
public class LivreApiController {

    @Autowired
    private LivreRepository livreRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @GetMapping("/{idLivre}")
    public LivreInfo getLivreInfo(@PathVariable int idLivre) {
        Livre livre = livreRepository.findById(idLivre)
                .orElseThrow(() -> new RuntimeException("Livre non trouvé"));

        List<Exemplaire> exemplaires = exemplaireRepository.findAll().stream()
                .filter(e -> e.getLivre().getIdLivre() == idLivre)
                .collect(Collectors.toList());

        List<ExemplaireInfo> exemplaireInfos = new ArrayList<>();
        for (Exemplaire e : exemplaires) {
            exemplaireInfos.add(new ExemplaireInfo(e.getIdExemplaire(), e.getStatut().name()));
        }

        return new LivreInfo(livre.getTitre(), livre.getAuteur(), exemplaireInfos);
    }

    // Classes pour structurer la réponse JSON
    public static class LivreInfo {
        private String titre;
        private String auteur;
        private List<ExemplaireInfo> exemplaires;

        public LivreInfo(String titre, String auteur, List<ExemplaireInfo> exemplaires) {
            this.titre = titre;
            this.auteur = auteur;
            this.exemplaires = exemplaires;
        }

        public String getTitre() { return titre; }
        public String getAuteur() { return auteur; }
        public List<ExemplaireInfo> getExemplaires() { return exemplaires; }
    }

    public static class ExemplaireInfo {
        private int idExemplaire;
        private String statut;

        public ExemplaireInfo(int idExemplaire, String statut) {
            this.idExemplaire = idExemplaire;
            this.statut = statut;
        }

        public int getIdExemplaire() { return idExemplaire; }
        public String getStatut() { return statut; }
    }
}