package com.biblio.service;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.biblio.exception.PretException;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.Pret;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.PretRepository;
import com.biblio.service.PenaliteService;


@Service
public class RetourService {

    @Autowired
    private PretRepository pretRepository;

    
    @Autowired
    private ExemplaireRepository exemplaireRepository;

     @Autowired
    private AdherentRepository adherentRepository;

      @Autowired
    private PenaliteService penaliteService;



   @Transactional
public void retournerExemplaire(int idPret, LocalDate dateRetourCustom) {
    Pret pret = pretRepository.findById(idPret)
            .orElseThrow(() -> new PretException("Le prêt n'existe pas."));
    
    if (pret.getDateRetourEffective() != null) {
        throw new PretException("Le prêt a déjà été retourné.");
    }

    // Utilise la date fournie ou la date actuelle si non fournie
    LocalDate dateRetour = dateRetourCustom != null ? dateRetourCustom : LocalDate.now();
    pret.setDateRetourEffective(dateRetour);
    pret.setStatut(Pret.Statut.RETOURNE); // Ajout important

    Exemplaire exemplaire = pret.getExemplaire();
    exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);
    
    Adherent adherent = pret.getAdherent();
    if (adherent.getQuotaRestant() != null) {
        adherent.setQuotaRestant(adherent.getQuotaRestant() + 1); // Incrémentation unique
    }

    // Vérifie et applique une pénalité si retard
    if (dateRetour.isAfter(pret.getDateRetourPrevue())) {
        penaliteService.appliquerPenalite(idPret);
    }

    pretRepository.save(pret);
    exemplaireRepository.save(exemplaire);
    if (adherent.getQuotaRestant() != null && adherent.getQuotaRestant() <= adherent.getProfil().getQuotaPret()) {
        adherentRepository.save(adherent); // Sauvegarde uniquement si le quota est valide
    }
}

// Surcharge pour la compatibilité
public void retournerExemplaire(int idPret) {
    retournerExemplaire(idPret, null);
}
    
}
