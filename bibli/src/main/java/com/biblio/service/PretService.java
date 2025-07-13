package com.biblio.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.DayOfWeek;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.biblio.exception.PretException;
import com.biblio.model.Abonnement;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.JourFerie;
import com.biblio.model.Pret;
import com.biblio.model.Profil;
import com.biblio.repository.AbonnementRepository;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.JourFerieRepository;
import com.biblio.repository.PretRepository;

@Service
public class PretService {

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private JourFerieRepository jourFerieRepository;

    @Transactional
    public Pret preterExemplaire(int idAdherent, int idExemplaire, String typePret) {
        System.out.println("Début preterExemplaire: idAdherent=" + idAdherent + ", idExemplaire=" + idExemplaire + ", typePret=" + typePret);

        // Valider l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));
        System.out.println("Adhérent trouvé: " + adherent.getIdAdherent() + ", Statut: " + adherent.getStatut());

        // Vérifier le statut de l'adhérent
        if (adherent.getStatut() == Adherent.StatutAdherent.SANCTIONNE) {
            throw new PretException("L'adhérent est sous sanction.");
        }

        // Vérifier l'abonnement actif
        LocalDate currentDate = LocalDate.now();
        Abonnement abonnement = abonnementRepository.findActiveAbonnementByAdherent(idAdherent, currentDate);
        if (abonnement == null) {
            throw new PretException("Aucun abonnement actif trouvé pour cet adhérent.");
        }
        System.out.println("Abonnement trouvé: " + abonnement.getIdAbonnement());

        // Vérifier l'exemplaire
        Exemplaire exemplaire = exemplaireRepository.findById(idExemplaire)
                .orElseThrow(() -> new PretException("L'exemplaire n'existe pas."));
        System.out.println("Exemplaire trouvé: " + exemplaire.getIdExemplaire() + ", Statut: " + exemplaire.getStatut());
        if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
            throw new PretException("L'exemplaire n'est pas disponible.");
        }

        // Vérifier la restriction d'âge
        int age = LocalDate.now().getYear() - adherent.getDateNaissance().getYear();
        if (exemplaire.getLivre().getRestrictionAge() > age) {
            throw new PretException("L'adhérent ne satisfait pas à la restriction d'âge.");
        }

        // Vérifier la restriction professeur
        if (exemplaire.getLivre().isProfesseurSeulement() && adherent.getProfil().getTypeProfil() != Profil.TypeProfil.PROFESSEUR) {
            throw new PretException("Livre réservé aux professeurs.");
        }

        // Vérifier le quota de prêts
        long activePrets = pretRepository.countActivePretsByAdherent(idAdherent);
        System.out.println("Nombre de prêts actifs: " + activePrets + ", Quota: " + adherent.getProfil().getQuotaPret()+ ", Quota restant: " + adherent.getQuotaRestant());
        if (activePrets >= adherent.getProfil().getQuotaPret() || adherent.getQuotaRestant() <= 0) {
            throw new PretException("L'adhérent a atteint son quota de prêts.");
        }
        adherent.setQuotaRestant(adherent.getQuotaRestant() - 1);
        adherentRepository.save(adherent);  

        // Calculer la date de retour prévue
        LocalDateTime datePret = LocalDateTime.now();
        LocalDateTime dateRetourPrevue = datePret.plusDays(adherent.getProfil().getDureePret());
        System.out.println("Date prêt: " + datePret + ", Date retour prévue: " + dateRetourPrevue);

        // Vérifier les jours fériés
        List<JourFerie> joursFeries = jourFerieRepository.findByDateFerieBetween(
                datePret.toLocalDate(), dateRetourPrevue.toLocalDate());
        for (JourFerie jour : joursFeries) {
            System.out.println("Jour férié trouvé: " + jour.getDateFerie());
            if (jour.getRegleRendu() == JourFerie.RegleRendu.AVANT
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.minusDays(1);
            } else if (jour.getRegleRendu() == JourFerie.RegleRendu.APRES
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.plusDays(1);
            }
        }

        while (dateRetourPrevue.getDayOfWeek() == DayOfWeek.SATURDAY || 
               dateRetourPrevue.getDayOfWeek() == DayOfWeek.SUNDAY) {
            System.out.println("Date retour prévue tombe un week-end: " + dateRetourPrevue);
            dateRetourPrevue = dateRetourPrevue.minusDays(1); // Avancer au vendredi précédent
        }

        //si je veux que ça soit repousser au lundi (apres au lieu d'avant)
        /* while (dateRetourPrevue.getDayOfWeek() == DayOfWeek.SATURDAY || 
            dateRetourPrevue.getDayOfWeek() == DayOfWeek.SUNDAY) {
            System.out.println("Date retour prévue tombe un week-end: " + dateRetourPrevue);
            dateRetourPrevue = dateRetourPrevue.plusDays(1); // Repousser au lundi suivant
        } */

        joursFeries = jourFerieRepository.findByDateFerieBetween(
                datePret.toLocalDate(), dateRetourPrevue.toLocalDate());
        for (JourFerie jour : joursFeries) {
            System.out.println("Jour férié trouvé après ajustement: " + jour.getDateFerie());
            if (jour.getRegleRendu() == JourFerie.RegleRendu.AVANT
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.minusDays(1);
            } else if (jour.getRegleRendu() == JourFerie.RegleRendu.APRES
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.plusDays(1);
            }
        }

        System.out.println("Date retour prévue ajustée: " + dateRetourPrevue);

        // Créer le prêt
        Pret pret = new Pret();
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        try {
            pret.setTypePret(Pret.TypePret.valueOf(typePret.replace(" ", "_").toUpperCase()));
        } catch (IllegalArgumentException e) {
            System.out.println("Erreur typePret: " + typePret);
            throw new PretException("Type de prêt invalide: " + typePret);
        }
        pret.setDatePret(datePret);
        pret.setDateRetourPrevue(dateRetourPrevue);

        // Mettre à jour le statut de l'exemplaire
        exemplaire.setStatut(Pret.TypePret.valueOf(typePret.replace(" ", "_").toUpperCase()) == Pret.TypePret.DOMICILE
                ? Exemplaire.StatutExemplaire.EN_PRET
                : Exemplaire.StatutExemplaire.LECTURE_SUR_PLACE);
        System.out.println("Nouveau statut exemplaire: " + exemplaire.getStatut());

        // Enregistrer les changements
        try {
            exemplaireRepository.save(exemplaire);
            System.out.println("Exemplaire enregistré: " + exemplaire.getIdExemplaire());
            pretRepository.save(pret);
            System.out.println("Prêt enregistré: " + pret.getIdPret());
            return pret; // Retourner l'objet Pret
        } catch (Exception e) {
            e.printStackTrace();
            throw new PretException("Erreur lors de l'enregistrement du prêt: " + e.getMessage());
        }
    }

   
}