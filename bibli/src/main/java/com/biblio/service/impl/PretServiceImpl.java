package com.biblio.service.impl;

import com.biblio.exception.BibliothequeException;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.Penalite;
import com.biblio.model.Pret;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.PenaliteRepository;
import com.biblio.repository.PretRepository;
import com.biblio.service.PretService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class PretServiceImpl implements PretService {

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private PenaliteRepository penaliteRepository;

    @Autowired
    private PretRepository pretRepository;

    @Override
    public Pret preterLivre(Long adherentId, Long exemplaireId, String typePret) throws BibliothequeException {
        // Vérification des règles de gestion
        Adherent adherent = adherentRepository.findById(adherentId)
                .orElseThrow(() -> new BibliothequeException("Adhérent n'existe pas."));

        if (!adherent.isActif()) {
            throw new BibliothequeException("Adhérent inactif.");
        }

        if (adherent.getDateExpirationAbonnement() != null && adherent.getDateExpirationAbonnement().isBefore(LocalDate.now())) {
            throw new BibliothequeException("Abonnement expiré jusqu'au " + adherent.getDateExpirationAbonnement());
        }

        Exemplaire exemplaire = exemplaireRepository.findById(exemplaireId)
                .orElseThrow(() -> new BibliothequeException("Exemplaire n'existe pas."));

        if (!exemplaire.isDisponible()) {
            throw new BibliothequeException("Exemplaire non disponible.");
        }

        if (adherent.getQuotaPret() <= 0) {
            throw new BibliothequeException("Quota de prêt dépassé.");
        }

        List<Penalite> penalites = penaliteRepository.findActivePenalitesByAdherentId(adherentId, LocalDate.now());
        if (!penalites.isEmpty()) {
            Penalite penalite = penalites.get(0);
            throw new BibliothequeException("Adhérent sous pénalité jusqu'à " + penalite.getDateFin() + ". Raison : " + penalite.getRaison());
        }

        // Création du prêt
        Pret pret = new Pret();
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        pret.setDatePret(LocalDate.now());
        pret.setDateRetourPrevu(LocalDate.now().plusDays(14)); // Exemple : 14 jours
        pret.setTypePret(Pret.TypePret.valueOf(typePret.toUpperCase()));

        // Mise à jour des états
        adherent.setQuotaPret(adherent.getQuotaPret() - 1);
        exemplaire.setDisponible(false);

        // Sauvegarde dans la base
        adherentRepository.save(adherent);
        exemplaireRepository.save(exemplaire);
        return pretRepository.save(pret);
    }
}