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
    public Abonnement activerAbonnement(int idAdherent, LocalDate dateDebut, LocalDate dateFin, double montant) {
        System.out.println("Début activerAbonnement: idAdherent=" + idAdherent + ", dateDebut=" + dateDebut + ", dateFin=" + dateFin);

        // Valider l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));

        // Créer l'abonnement
        Abonnement abonnement = new Abonnement();
        abonnement.setAdherent(adherent);
        abonnement.setDateDebut(dateDebut);
        abonnement.setDateFin(dateFin);
        abonnement.setMontant(montant);
        abonnement.setStatut(Abonnement.StatutAbonnement.ACTIVE);

        // Réinitialiser le quota restant
        adherent.setQuotaRestant(adherent.getProfil().getQuotaPret());
        adherentRepository.save(adherent);

        // Enregistrer l'abonnement
        try {
            abonnementRepository.save(abonnement);
            System.out.println("Abonnement activé: " + abonnement.getIdAbonnement() + ", Quota restant réinitialisé: " + adherent.getQuotaRestant());
            return abonnement;
        } catch (Exception e) {
            e.printStackTrace();
            throw new PretException("Erreur lors de l'activation de l'abonnement: " + e.getMessage());
        }
    }
}