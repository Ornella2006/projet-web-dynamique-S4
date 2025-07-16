package com.biblio.service;

import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.biblio.exception.PretException;
import com.biblio.model.Abonnement;
import com.biblio.model.Adherent;
import com.biblio.repository.AbonnementRepository;
import com.biblio.repository.AdherentRepository;

@Service
public class AbonnementService {

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private AdherentRepository adherentRepository;

    @Transactional
    public Abonnement renouvelerAbonnement(int idAdherent, LocalDate debut, LocalDate fin, double montant) throws PretException {
        System.out.println("Début renouvelerAbonnement: idAdherent=" + idAdherent + ", debut=" + debut + ", fin=" + fin);

        // Valider l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));

        // Vérifier s'il existe une cotisation active
        if (abonnementRepository.existsByAdherentAndDateFinAfter(adherent, LocalDate.now())) {
            throw new PretException("Une cotisation active existe déjà.");
        }

        // Créer l'abonnement
        Abonnement abonnement = new Abonnement();
        abonnement.setAdherent(adherent);
        abonnement.setDateDebut(debut);
        abonnement.setDateFin(fin);
        abonnement.setMontant(montant);
        abonnement.setStatut(Abonnement.Statut.ACTIVE);

        // Réinitialiser le quota restant
        adherent.setQuotaRestant(adherent.getProfil().getQuotaPret());
        adherentRepository.save(adherent);

        // Enregistrer l'abonnement
        try {
            abonnementRepository.save(abonnement);
            System.out.println("Abonnement renouvelé: " + abonnement.getIdAbonnement() + ", Quota restant réinitialisé: " + adherent.getQuotaRestant());
            return abonnement;
        } catch (Exception e) {
            e.printStackTrace();
            throw new PretException("Erreur lors du renouvellement de l'abonnement: " + e.getMessage());
        }
    }
}