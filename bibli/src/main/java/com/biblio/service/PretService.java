package com.biblio.service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.biblio.exception.PretException;
import com.biblio.model.Abonnement;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.JourFerie;
import com.biblio.model.Pret;
import com.biblio.model.Profil;
import com.biblio.model.Prolongement;
import com.biblio.model.Reservation;
import com.biblio.repository.AbonnementRepository;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.JourFerieRepository;
import com.biblio.repository.PretRepository;
import com.biblio.repository.ProlongementRepository;
import com.biblio.repository.ReservationRepository;

@Service
public class PretService {

    @Autowired
    private PretRepository pretRepository;
    @Autowired
    private ProlongementRepository prolongementRepository;
    @Autowired
    private AdherentRepository adherentRepository;
   
   
    @Autowired
    private ExemplaireRepository exemplaireRepository;
    @Autowired
    private JourFerieRepository jourFerieRepository;
    @Autowired
    private AbonnementRepository abonnementRepository;
    @Autowired
    private ReservationRepository reservationRepository;

    @Value("${prolongation.jours_avance:2}") // Configurable via application.properties
    private int joursAvanceMin;

 @Transactional
public Pret preterExemplaire(int idAdherent, int idExemplaire, String typePret, LocalDate datePret, LocalDate dateRetourPrevue, Model model) {
    List<String> errors = new ArrayList<>();

    Adherent adherent = adherentRepository.findById(idAdherent).orElse(null);
    if (adherent == null) {
        errors.add("L'adhérent n'existe pas.");
    } else {
        if (adherent.getStatut() == Adherent.StatutAdherent.SANCTIONNE) {
            errors.add("L'adhérent est sous sanction jusqu'à " + adherent.getDateFinSanction() + ".");
        }
        LocalDate currentDate = LocalDate.now();
        Abonnement abonnement = abonnementRepository.findActiveAbonnementByAdherent(adherent, currentDate).orElse(null);
        if (abonnement == null) {
            errors.add("Aucune cotisation active trouvée.");
        }
        long activeLoans = pretRepository.countActivePretsByAdherent(idAdherent);
        if (activeLoans >= adherent.getProfil().getQuotaPret()) {
            errors.add("L'adhérent a atteint son quota de prêts.");
        }
    }

    Exemplaire exemplaire = exemplaireRepository.findById(idExemplaire).orElse(null);
    if (exemplaire == null) {
        errors.add("L'exemplaire n'existe pas.");
    } else if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
        errors.add("L'exemplaire n'est pas disponible.");
    }

    if (!errors.isEmpty()) {
        throw new PretException(String.join(" et ", errors));
    }

    LocalDate effectiveDatePret = datePret != null ? datePret : LocalDate.now();
    if (isWeekendOrHoliday(effectiveDatePret)) {
        throw new PretException("La date de prêt ne peut pas être un week-end ou un jour férié. Veuillez choisir une autre date.");
    }

    if (adherent != null && exemplaire != null) {
        int age = Period.between(adherent.getDateNaissance(), LocalDate.now()).getYears();
        if (exemplaire.getLivre().getRestrictionAge() > age) {
            throw new PretException("L'adhérent ne satisfait pas à la restriction d'âge.");
        }
        if (exemplaire.getLivre().isENSEIGNANTSeulement() && adherent.getProfil().getTypeProfil() != Profil.TypeProfil.ENSEIGNANT) {
            throw new PretException("Livre réservé aux ENSEIGNANTs.");
        }

        if (dateRetourPrevue == null) {
            dateRetourPrevue = effectiveDatePret.plusDays(adherent.getProfil().getDureePret());
        }

        LocalDate adjustedDateRetourPrevue = ajusterPourJoursFeries(dateRetourPrevue);
        if (!adjustedDateRetourPrevue.equals(dateRetourPrevue)) {
            System.out.println("Ajustement de la date de retour : de " + dateRetourPrevue + " à " + adjustedDateRetourPrevue + " en raison d'un jour férié ou week-end.");
        }

        Pret pret = new Pret();
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        pret.setTypePret(Pret.TypePret.valueOf(typePret.replace(" ", "_").toUpperCase()));
        pret.setDatePret(effectiveDatePret);
        pret.setDateRetourPrevue(adjustedDateRetourPrevue);

        exemplaire.setStatut(pret.getTypePret() == Pret.TypePret.DOMICILE
                ? Exemplaire.StatutExemplaire.EN_PRET
                : Exemplaire.StatutExemplaire.LECTURE_SUR_PLACE);
        exemplaireRepository.save(exemplaire);
        pretRepository.save(pret);

        if (adherent.getQuotaRestant() == null) {
            adherent.setQuotaRestant(adherent.getProfil().getQuotaPret());
        }
        adherent.setQuotaRestant(adherent.getQuotaRestant() - 1);
        adherentRepository.save(adherent);

        // Retourner le prêt avec la date ajustée
        return pret;
    }
    return null;
}

private LocalDate ajusterPourJoursFeries(LocalDate date) {
    List<JourFerie> joursFeries = jourFerieRepository.findAll();
    LocalDate dateAjustee = date;
    boolean ajustementNecessaire;

    do {
        ajustementNecessaire = false;
        // Vérification des week-ends (décaler au lundi si dimanche, ou au vendredi si samedi)
        if (dateAjustee.getDayOfWeek() == DayOfWeek.SATURDAY) {
            dateAjustee = dateAjustee.minusDays(1); // Décaler au vendredi
            ajustementNecessaire = true;
        } else if (dateAjustee.getDayOfWeek() == DayOfWeek.SUNDAY) {
            dateAjustee = dateAjustee.minusDays(2); // Décaler au lundi
            ajustementNecessaire = true;
        }
        // Vérification des jours fériés
        for (JourFerie jourFerie : joursFeries) {
            if (jourFerie.getDateFerie().equals(dateAjustee)) {
                ajustementNecessaire = true;
                if (jourFerie.getRegleRendu() == JourFerie.RegleRendu.AVANT) {
                    dateAjustee = dateAjustee.minusDays(1);
                } else {
                    dateAjustee = dateAjustee.minusDays(2);
                }
                /* if (jourFerie.getRegleRendu() == JourFerie.RegleRendu.APRES) {
                    dateAjustee = dateAjustee.plusDays(1);
                } else {
                    dateAjustee = dateAjustee.plusDays(1);
                } */
                break;
            }
        }
    } while (ajustementNecessaire);

    return dateAjustee;
}

// Méthode utilitaire pour vérifier si une date est un week-end ou un jour férié
private boolean isWeekendOrHoliday(LocalDate date) {
    DayOfWeek day = date.getDayOfWeek();
    if (day == DayOfWeek.SATURDAY || day == DayOfWeek.SUNDAY) {
        return true;
    }
    return jourFerieRepository.existsByDateFerie(date);
}

    // Surcharge pour la compatibilité avec l'appel existant
    public Pret preterExemplaire(int idAdherent, int idExemplaire, String typePret) {
        return preterExemplaire(idAdherent, idExemplaire, typePret, null, null, null);
    }

    @Value("${prolongation.max_parallele:2}") // Maximum de prolongements parallèles
    private int maxProlongementsParalleles;

    @Transactional
public Prolongement demanderProlongation(int idPret, LocalDate nouvelleDateRetour, HttpSession session) throws PretException {
    com.biblio.model.User user = (com.biblio.model.User) session.getAttribute("user");
    if (user == null || user.getRole() != com.biblio.model.User.Role.ADHERENT) {
        throw new PretException("Utilisateur non connecté ou non autorisé.");
    }

    Pret pret = pretRepository.findById(idPret)
            .orElseThrow(() -> new PretException("Prêt inexistant."));
            LocalDate currentDate = LocalDate.now();
    
    Adherent adherent = pret.getAdherent();
    Abonnement abonnement = abonnementRepository.findActiveAbonnementByAdherent(adherent, currentDate)
            .orElseThrow(() -> new PretException("Cotisation inactive."));
    if (!adherent.isCotisationActive()) {
        throw new PretException("Cotisation inactive.");
    }
    if (adherent.isSanctionne()) {
        throw new PretException("Adhérent sous sanction jusqu'à la fin de la pénalité.");
    }
    if (abonnement.getDateFin().isBefore(currentDate.plusDays(7))) {
        throw new PretException("L'abonnement est bientôt terminé. Veuillez le renouveler avant de demander une prolongation.");
    }
    if (pret.getDateRetourEffective() != null) {
        throw new PretException("Prêt déjà retourné.");
    }
    long prolongementsEnCours = prolongementRepository.countByAdherentAndStatut(adherent, Prolongement.StatutProlongement.EN_ATTENTE);
    if (prolongementsEnCours >= maxProlongementsParalleles) {
        throw new PretException("Quota de prolongements parallèles (" + maxProlongementsParalleles + ") dépassé.");
    }
    if (pret.getProlongationCount() >= adherent.getProfil().getQuotaProlongement()) {
        throw new PretException("Quota de prolongements total dépassé.");
    }
    LocalDate dateLimite = pret.getDateRetourPrevue().minusDays(joursAvanceMin);
    if (LocalDate.now().isAfter(dateLimite)) {
        throw new PretException("Demande trop tardive, " + joursAvanceMin + " jours d'avance requis.");
    }
    if (reservationRepository.existsByExemplaireAndStatut(pret.getExemplaire(), Reservation.Statut.VALIDEE)) {
        throw new PretException("Impossible de prolonger, exemplaire réservé.");
    }

    LocalDate dateAjustee = ajusterPourJoursFeries(nouvelleDateRetour);
    Prolongement prolongement = new Prolongement();
    Prolongement savedProlongement = prolongementRepository.save(prolongement);
System.out.println("Prolongement sauvegardé avec ID: " + savedProlongement.getIdProlongement());
return savedProlongement;
}

    @Transactional
    public void validerProlongation(int idProlongement) throws PretException {
        Prolongement prolongement = prolongementRepository.findById(idProlongement)
                .orElseThrow(() -> new PretException("Prolongement inexistant."));
        if (prolongement.getStatut() != Prolongement.StatutProlongement.EN_ATTENTE) {
            throw new PretException("Prolongement déjà traité.");
        }

        Pret pret = prolongement.getPret();
        pret.setDateRetourPrevue(prolongement.getNouvelleDateRetour());
        pret.setProlongationCount(pret.getProlongationCount() + 1);
        prolongement.setStatut(Prolongement.StatutProlongement.VALIDE);
        pretRepository.save(pret);
        prolongementRepository.save(prolongement);
    }

    @Transactional
    public void rejeterProlongation(int idProlongement) throws PretException {
        Prolongement prolongement = prolongementRepository.findById(idProlongement)
                .orElseThrow(() -> new PretException("Prolongement inexistant."));
        if (prolongement.getStatut() != Prolongement.StatutProlongement.EN_ATTENTE) {
            throw new PretException("Prolongement déjà traité.");
        }
        prolongement.setStatut(Prolongement.StatutProlongement.REFUSE);
        prolongementRepository.save(prolongement);
    }


    public List<Pret> findPretsByAdherentId(int idAdherent) {
        return pretRepository.findAll().stream()
                .filter(p -> p.getAdherent().getIdAdherent() == idAdherent)
                .toList();
    }
}