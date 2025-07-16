package com.biblio.service;

import com.biblio.exception.PretException;
import com.biblio.model.Adherent;
import com.biblio.model.Penalite;
import com.biblio.model.Pret;
import com.biblio.model.JourFerie;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.PenaliteRepository;
import com.biblio.repository.PretRepository;
import com.biblio.repository.JourFerieRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class PenaliteService {

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private PenaliteRepository penaliteRepository;

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private JourFerieRepository jourFerieRepository;

    @Transactional
public void appliquerPenalite(int idPret) throws PretException {
    // Récupérer le prêt
    Pret pret = pretRepository.findById(idPret)
            .orElseThrow(() -> new PretException("Prêt inexistant."));

    // Ajuster la date de retour prévue pour les jours fériés
    LocalDate adjustedDateRetourPrevue = ajusterPourJoursFeries(pret.getDateRetourPrevue());

    // Vérifier s'il y a un retard en comparant avec la date ajustée
    if (pret.getDateRetourEffective() != null && pret.getDateRetourEffective().isAfter(adjustedDateRetourPrevue)) {
        Adherent adherent = pret.getAdherent();
        if (adherent == null) {
            throw new PretException("Adhérent inexistant pour ce prêt.");
        }

        // Calculer la durée de la pénalité basée sur le profil
        int dureePenalite = adherent.getProfil().getDureePenalite();

        // Convertir la date de retour effective en LocalDate pour correspondre à la table
        LocalDate dateDebutPenalite = pret.getDateRetourEffective();
        LocalDate dateFinPenalite = ajusterPourJoursFeries(dateDebutPenalite.plusDays(dureePenalite));

        // Vérifier les pénalités existantes pour cumuler si nécessaire
        List<Penalite> penalitesExistantes = penaliteRepository.findByAdherentAndDateFinAfter(adherent, LocalDate.now());
        LocalDate nouvelleDateFinPenalite = dateFinPenalite;
        if (!penalitesExistantes.isEmpty()) {
            Penalite dernierePenalite = penalitesExistantes.get(penalitesExistantes.size() - 1);
            nouvelleDateFinPenalite = dernierePenalite.getDateFinPenalite().plusDays(dureePenalite);
            nouvelleDateFinPenalite = ajusterPourJoursFeries(nouvelleDateFinPenalite);
        }

        // Créer et sauvegarder la pénalité
        Penalite penalite = new Penalite();
        penalite.setAdherent(adherent);
        penalite.setPret(pret);
        penalite.setDateDebutPenalite(dateDebutPenalite);
        penalite.setDateFinPenalite(nouvelleDateFinPenalite);
        penalite.setRaison("Retard de retour du prêt ID: " + idPret);
        penaliteRepository.save(penalite);

        // Mettre à jour le statut de l'adhérent
        adherent.setStatut(Adherent.StatutAdherent.SANCTIONNE);
        adherent.setDateFinSanction(nouvelleDateFinPenalite);
        adherentRepository.save(adherent);
    }
}

private LocalDate ajusterPourJoursFeries(LocalDate date) {
    List<JourFerie> joursFeries = jourFerieRepository.findAll();
    LocalDate dateAjustee = date;
    boolean ajustementNecessaire;

    do {
        ajustementNecessaire = false;
        for (JourFerie jourFerie : joursFeries) {
            if (jourFerie.getDateFerie().equals(dateAjustee)) {
                ajustementNecessaire = true;
                if (jourFerie.getRegleRendu() == JourFerie.RegleRendu.AVANT) {
                    dateAjustee = dateAjustee.minusDays(1);
                } else {
                    dateAjustee = dateAjustee.plusDays(1);
                }
                break;
            }
        }
    } while (ajustementNecessaire);

    return dateAjustee;
}

   public List<Penalite> findAllPenalites() {
    return penaliteRepository.findAll();
}
}