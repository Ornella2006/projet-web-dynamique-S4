package com.biblio.service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.biblio.exception.PretException;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.JourFerie;
import com.biblio.model.Livre;
import com.biblio.model.Pret;
import com.biblio.model.Profil;
import com.biblio.model.Reservation;
import com.biblio.model.Reservation.Statut;
import com.biblio.repository.*;
import com.biblio.service.PretService;

@Service
public class ReservationService {

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private LivreRepository livreRepository;

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private PretService pretService;

    @Autowired
    private JourFerieRepository jourFerieRepository;

    @Autowired
    private AbonnementRepository abonnementRepository;

    public List<Exemplaire> findAllExemplairesWithLivres() {
        List<Exemplaire> exemplaires = exemplaireRepository.findAllWithLivre();
        for (Exemplaire e : exemplaires) {
            System.out.println("Exemplaire ID: " + e.getIdExemplaire() + ", Livre: " + e.getLivre().getTitre());
        }
        return exemplaires;
    }

    @Transactional
public Reservation reserverExemplaire(int idAdherent, int idExemplaire, String typePret, LocalDate dateRetraitPrevue) {
    List<String> errors = new ArrayList<>();

    // Valider l'adhérent
    Adherent adherent = adherentRepository.findById(idAdherent).orElse(null);
    if (adherent == null) {
        errors.add("L'adhérent n'existe pas.");
    } else {
        if (adherent.getStatut() == Adherent.StatutAdherent.SANCTIONNE) {
            errors.add("L'adhérent est sous sanction.");
        }
        if (!hasActiveSubscription(adherent)) {
            errors.add("Aucune cotisation active trouvée.");
        }
        // Initialiser quotaRestant s'il est null
        if (adherent.getQuotaRestant() == null) {
            adherent.setQuotaRestant(adherent.getProfil().getQuotaReservation()); // Initialiser avec le quota par défaut
            adherentRepository.save(adherent);
        }
    }

    // Vérifier l'exemplaire
    Exemplaire exemplaire = exemplaireRepository.findById(idExemplaire).orElse(null);
    if (exemplaire == null) {
        errors.add("L'exemplaire n'existe pas.");
    } else {
        if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
            errors.add("L'exemplaire n'est pas disponible pour la date sélectionnée.");
        }
    }

    // Si des erreurs sont présentes, les combiner et lever une exception
    if (!errors.isEmpty()) {
        throw new PretException(String.join(" et ", errors));
    }

    // Vérifications supplémentaires
    if (adherent != null && exemplaire != null) {
        int age = LocalDate.now().getYear() - adherent.getDateNaissance().getYear();
        if (exemplaire.getLivre().getRestrictionAge() > age) {
            throw new PretException("L'adhérent ne satisfait pas à la restriction d'âge.");
        }
        if (exemplaire.getLivre().isENSEIGNANTSeulement() && adherent.getProfil().getTypeProfil() != Profil.TypeProfil.ENSEIGNANT) {
            throw new PretException("Livre réservé aux ENSEIGNANTs.");
        }

        long activeReservations = reservationRepository.countByAdherentAndStatutNotIn(adherent, Arrays.asList(Statut.ANNULEE, Statut.EXPIREE));
        if (activeReservations >= adherent.getProfil().getQuotaReservation()) {
            throw new PretException("Quota de réservations dépassé.");
        }

        LocalDate adjustedDateRetraitPrevue = ajusterPourJoursFeries(dateRetraitPrevue);
        LocalDate now = LocalDate.now();
        LocalDate dateExpiration = now.plusDays(7);
        Reservation reservation = new Reservation(exemplaire, adherent, now, adjustedDateRetraitPrevue, dateExpiration, Reservation.TypePret.valueOf(typePret.toUpperCase().replace("LECTURE_SUR_PLACE", "SUR_PLACE")));
        adherent.setQuotaRestant(adherent.getQuotaRestant() - 1); // Utilisation sécurisée après initialisation
        adherentRepository.save(adherent);
        return reservationRepository.save(reservation);
    }
    return null;
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
        // Vérifier aussi les week-ends
        if (dateAjustee.getDayOfWeek() == DayOfWeek.SATURDAY) {
            dateAjustee = dateAjustee.minusDays(1);
            ajustementNecessaire = true;
        } else if (dateAjustee.getDayOfWeek() == DayOfWeek.SUNDAY) {
            dateAjustee = dateAjustee.minusDays(2); // Passer au lundi
            ajustementNecessaire = true;
        }
    } while (ajustementNecessaire);

    return dateAjustee;
}

    public List<Reservation> findPendingReservations() {
        return reservationRepository.findByStatut(Statut.EN_ATTENTE);
    }

    @Transactional
public void validerReservation(int idReservation) {
    Reservation reservation = reservationRepository.findById(idReservation)
            .orElseThrow(() -> new PretException("La réservation n'existe pas."));
    if (reservation.getStatut() != Statut.EN_ATTENTE) {
        throw new PretException("La réservation ne peut pas être validée.");
    }
    if (reservation.getExemplaire().getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
        throw new PretException("L'exemplaire n'est plus disponible.");
    }
    reservation.setStatut(Statut.VALIDEE);
    reservationRepository.save(reservation);
}

    @Transactional
    public void rejeterReservation(int idReservation) {
        Reservation reservation = reservationRepository.findById(idReservation)
                .orElseThrow(() -> new PretException("La réservation n'existe pas."));
        if (reservation.getStatut() != Statut.EN_ATTENTE) {
            throw new PretException("La réservation ne peut pas être rejetée.");
        }
        reservation.setStatut(Statut.ANNULEE);
        reservation.getAdherent().setQuotaRestant(reservation.getAdherent().getQuotaRestant() + 1);
        reservationRepository.save(reservation);
        adherentRepository.save(reservation.getAdherent());
    }

   @Transactional
public void convertToPret(int idReservation, int idAdherent) {
    Reservation reservation = reservationRepository.findById(idReservation)
            .orElseThrow(() -> new PretException("La réservation n'existe pas."));
    if (reservation.getStatut() != Statut.VALIDEE) {
        throw new PretException("La réservation doit être validée pour être convertie en prêt.");
    }
    LocalDate today = LocalDate.now();
    LocalDate dateRetraitPrevue = reservation.getDateRetraitPrevue();
    System.out.println("Today: " + today + ", Date Retrait Prévue: " + dateRetraitPrevue);
    if (!today.isEqual(dateRetraitPrevue)) {
        throw new PretException("La conversion en prêt n'est possible que le jour exact de la date de retrait prévue (" + dateRetraitPrevue + ").");
    }

    Adherent adherent = adherentRepository.findById(idAdherent)
            .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));
    Exemplaire exemplaire = reservation.getExemplaire();

    List<String> errors = new ArrayList<>();
    if (adherent.getStatut() == Adherent.StatutAdherent.SANCTIONNE) {
        errors.add("L'adhérent est sous sanction.");
    }
    if (!hasActiveSubscription(adherent)) {
        errors.add("Aucune cotisation active trouvée.");
    }
    long activeLoans = pretRepository.countByAdherentAndStatutNotIn(adherent, Arrays.asList(Pret.Statut.RETOURNE));
    if (activeLoans >= adherent.getProfil().getQuotaPret()) {
        errors.add("Quota de prêts dépassé.");
    }
    if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
        errors.add("L'exemplaire n'est plus disponible.");
    }
    int age = Period.between(adherent.getDateNaissance(), LocalDate.now()).getYears();
    if (exemplaire.getLivre().getRestrictionAge() > age) {
        errors.add("L'adhérent ne satisfait pas à la restriction d'âge.");
    }
    if (exemplaire.getLivre().isENSEIGNANTSeulement() && adherent.getProfil().getTypeProfil() != Profil.TypeProfil.ENSEIGNANT) {
        errors.add("Livre réservé aux ENSEIGNANTs.");
    }

    if (!errors.isEmpty()) {
        throw new PretException(String.join(" et ", errors));
    }

    // Conversion en prêt avec les dates optionnelles à gérer dans une nouvelle vue
    Pret pret = pretService.preterExemplaire(idAdherent, reservation.getExemplaire().getIdExemplaire(), reservation.getTypePret().name(), null, null, null);
    reservation.setStatut(Statut.CONVERTIE_EN_PRET);
    reservationRepository.save(reservation);
    exemplaire.setStatut(Exemplaire.StatutExemplaire.EN_PRET);
    exemplaireRepository.save(exemplaire);
}

 @Transactional
public void annulerReservationExpiree(Reservation reservation) {
    if (reservation.getStatut() == Statut.VALIDEE && 
        LocalDate.now().isAfter(reservation.getDateRetraitPrevue().plusDays(2))) { // Délai de 2 jours après la date prévue
        reservation.setStatut(Statut.EXPIREE);
        reservation.setDateExpiration(LocalDate.now());
        Exemplaire exemplaire = reservation.getExemplaire();
        exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);
        Adherent adherent = reservation.getAdherent();
        adherent.setQuotaRestant(adherent.getQuotaRestant() + 1);
        reservationRepository.save(reservation);
        exemplaireRepository.save(exemplaire);
        adherentRepository.save(adherent);
    }
}

    private boolean hasActiveSubscription(Adherent adherent) {
        LocalDate currentDate = LocalDate.now();
        return abonnementRepository.findActiveAbonnementByAdherent(adherent, currentDate).isPresent();
    }

    public List<Reservation> findValidatedReservations() {
        return reservationRepository.findByStatut(Statut.VALIDEE);
    }
}