x logs ou résultats si nécessaire !
par contre le ReservationService que vous m'avez fourni provoque des erreurs 
Le contenu complet de ReservationService.java :
package com.biblio.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.biblio.exception.PretException;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.Livre;
import com.biblio.model.Pret;
import com.biblio.model.Profil;
import com.biblio.model.Reservation;
import com.biblio.model.Reservation.Statut;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.LivreRepository;
import com.biblio.repository.PretRepository;
import com.biblio.repository.ReservationRepository;
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

    public List<Exemplaire> findAllExemplairesWithLivres() {
        return exemplaireRepository.findAllWithLivre();
    }

    @Transactional
    public Reservation reserverExemplaire(int idAdherent, int idExemplaire, String typePret, LocalDate dateRetraitPrevue) {
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));
        if (adherent.getStatut() == Adherent.StatutAdherent.SANCTIONNE) {
            throw new PretException("L'adhérent est sous sanction.");
        }
        if (!hasActiveSubscription(adherent)) {
            throw new PretException("Aucune cotisation active trouvée.");
        }
        Exemplaire exemplaire = exemplaireRepository.findById(idExemplaire)
                .orElseThrow(() -> new PretException("L'exemplaire n'existe pas."));
        if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
            throw new PretException("L'exemplaire n'est pas disponible pour la date sélectionnée.");
        }
        int age = LocalDate.now().getYear() - adherent.getDateNaissance().getYear();
        if (exemplaire.getLivre().getRestrictionAge() > age) {
            throw new PretException("L'adhérent ne satisfait pas à la restriction d'âge.");
        }
        if (exemplaire.getLivre().isProfesseurSeulement() && adherent.getProfil().getTypeProfil() != Profil.TypeProfil.PROFESSEUR) {
            throw new PretException("Livre réservé aux professeurs.");
        }
        long activeReservations = reservationRepository.countByAdherentAndStatutNotIn(adherent, List.of(Statut.ANNULEE, Statut.EXPIREE));
        if (activeReservations >= adherent.getProfil().getQuotaReservation()) {
            throw new PretException("Quota de réservations dépassé.");
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime dateExpiration = now.plusDays(7);
        Reservation reservation = new Reservation(exemplaire, adherent, now, dateRetraitPrevue, dateExpiration);
        adherent.setQuotaRestant(adherent.getQuotaRestant() - 1);
        adherentRepository.save(adherent);
        return reservationRepository.save(reservation);
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
        reservation.setStatut(Statut.VALIDEE);
        reservation.getExemplaire().setStatut(Exemplaire.StatutExemplaire.RESERVE);
        reservationRepository.save(reservation);
        exemplaireRepository.save(reservation.getExemplaire());
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
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));
        Exemplaire exemplaire = reservation.getExemplaire();

        // Créer un nouveau prêt
        Pret pret = new Pret();
        pret.setExemplaire(exemplaire);
        pret.setAdherent(adherent);
        pret.setTypePret(reservation.getTypePret()); // À ajuster si typePret est stocké dans Reservation
        pret.setDatePret(LocalDateTime.now());
        pret.setDateRetourPrevue(reservation.getDateRetraitPrevue().atStartOfDay().plusDays(adherent.getProfil().getDureePret()));
        pretRepository.save(pret);

        // Mettre à jour l'exemplaire et la réservation
        exemplaire.setStatut(Exemplaire.StatutExemplaire.EN_PRET);
        reservation.setStatut(Statut.ANNULEE); // La réservation est terminée une fois convertie
        exemplaireRepository.save(exemplaire);
        reservationRepository.save(reservation);
    }

    @Transactional
    public void annulerReservationExpiree(Reservation reservation) {
        if (reservation.getStatut() == Statut.EN_ATTENTE && LocalDateTime.now().isAfter(reservation.getDateExpiration())) {
            reservation.setStatut(Statut.EXPIREE);
            reservation.getAdherent().setQuotaRestant(reservation.getAdherent().getQuotaRestant() + 1);
            reservation.getExemplaire().setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);
            reservationRepository.save(reservation);
            adherentRepository.save(reservation.getAdherent());
            exemplaireRepository.save(reservation.getExemplaire());
        }
    }

    private boolean hasActiveSubscription(Adherent adherent) {
        return true; // À remplacer par une vraie vérification avec AbonnementRepository
    }

    public List<Reservation> findValidatedReservations() {
        return reservationRepository.findByStatut(Statut.VALIDEE);
    }
}

la ligne qui provoque des erreurs :
        pret.setTypePret(reservation.getTypePret()); // À ajuster si typePret est stocké dans Reservation
l'erreur => incompatible types: Enum<ChronoUnit> cannot be converted to TypePret en surlignant :
setTypePret(reservation.getTypePret()