package com.biblio.service;

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

@Service
public class RetourService {

    @Autowired
    private PretRepository pretRepository;

    
    @Autowired
    private ExemplaireRepository exemplaireRepository;

     @Autowired
    private AdherentRepository adherentRepository;



    @Transactional
    public void retournerExemplaire(int idPret) {
        System.out.println("Début retournerExemplaire: idPret=" + idPret);

        // Trouver le prêt
        Pret pret = pretRepository.findById(idPret)
                .orElseThrow(() -> new PretException("Le prêt n'existe pas."));
        if (pret.getDateRetourEffective() != null) {
            throw new PretException("Le prêt a déjà été retourné.");
        }

        // Mettre à jour la date de retour effective
        pret.setDateRetourEffective(LocalDateTime.now());

        // Mettre à jour le statut de l'exemplaire
        Exemplaire exemplaire = pret.getExemplaire();
        exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);

        // Incrémenter le quota restant de l'adhérent
        Adherent adherent = pret.getAdherent();
        adherent.setQuotaRestant(adherent.getQuotaRestant() + 1);

        // Enregistrer les changements
        try {
            pretRepository.save(pret);
            exemplaireRepository.save(exemplaire);
            adherentRepository.save(adherent);
            System.out.println("Prêt retourné: " + pret.getIdPret() + ", Exemplaire: " + exemplaire.getIdExemplaire() + ", Quota restant: " + adherent.getQuotaRestant());
        } catch (Exception e) {
            e.printStackTrace();
            throw new PretException("Erreur lors du retour du prêt: " + e.getMessage());
        }
    }
    
}
