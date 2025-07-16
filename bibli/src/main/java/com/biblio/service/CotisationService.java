package com.biblio.service;

import com.biblio.exception.PretException;
import com.biblio.model.Adherent;
import com.biblio.model.Abonnement;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.AbonnementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;

@Service
public class CotisationService {

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Transactional
    public void renouvelerCotisation(int idAdherent, LocalDate debut, LocalDate fin, BigDecimal montant) throws PretException {
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("Adhérent inexistant."));

        if (abonnementRepository.existsByAdherentAndDateFinAfter(adherent, LocalDate.now())) {
            throw new PretException("Une cotisation active existe déjà.");
        }

        Abonnement cotisation = new Abonnement();
        cotisation.setAdherent(adherent);
        cotisation.setDateDebut(debut);
        cotisation.setDateFin(fin);
        cotisation.setMontant(montant.doubleValue()); // Conversion BigDecimal en double
        cotisation.setStatut(Abonnement.Statut.ACTIVE);
        abonnementRepository.save(cotisation);

        // Pas de setCotisationActive, la logique est gérée par isCotisationActive()
    }
}