package com.biblio.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import org.mockito.MockitoAnnotations;

import com.biblio.exception.PretException;
import com.biblio.model.Abonnement;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.Livre;
import com.biblio.model.Pret;
import com.biblio.model.Profil;
import com.biblio.repository.AbonnementRepository;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.JourFerieRepository;
import com.biblio.repository.PretRepository;

public class PretServiceTest {

    @Mock
    private AdherentRepository adherentRepository;

    @Mock
    private ExemplaireRepository exemplaireRepository;

    @Mock
    private PretRepository pretRepository;

    @Mock
    private AbonnementRepository abonnementRepository;

    @Mock
    private JourFerieRepository jourFerieRepository;

    @InjectMocks
    private PretService pretService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testPreterExemplaireSuccess() {
        Adherent adherent = new Adherent();
        adherent.setIdAdherent(1);
        adherent.setStatut(Adherent.StatutAdherent.ACTIF);
        adherent.setDateNaissance(LocalDate.of(2000, 1, 1));
        Profil profil = new Profil();
        profil.setQuotaPret(3);
        profil.setDureePret(7);
        profil.setTypeProfil(Profil.TypeProfil.ETUDIANT);
        adherent.setProfil(profil);
        adherent.setQuotaRestant(3);

        Exemplaire exemplaire = new Exemplaire();
        exemplaire.setIdExemplaire(1);
        exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);
        Livre livre = new Livre();
        livre.setRestrictionAge(0);
        livre.setProfesseurSeulement(false);
        exemplaire.setLivre(livre);

        Abonnement abonnement = new Abonnement();
        abonnement.setStatut(Abonnement.StatutAbonnement.ACTIVE);
        abonnement.setDateDebut(LocalDate.now().minusDays(10));
        abonnement.setDateFin(LocalDate.now().plusDays(10));

        when(adherentRepository.findById(eq(1))).thenReturn(Optional.of(adherent));
        when(exemplaireRepository.findById(eq(1))).thenReturn(Optional.of(exemplaire));
        when(abonnementRepository.findActiveAbonnementByAdherent(eq(1), any(LocalDate.class))).thenReturn(abonnement);
        when(pretRepository.countActivePretsByAdherent(eq(1))).thenReturn(0L);
        when(jourFerieRepository.findByDateFerieBetween(any(LocalDate.class), any(LocalDate.class))).thenReturn(Collections.emptyList());
        when(pretRepository.save(any(Pret.class))).thenAnswer(invocation -> {
            Pret pret = invocation.getArgument(0);
            pret.setIdPret(1);
            return pret;
        });

        Pret pret = pretService.preterExemplaire(1, 1, "DOMICILE");

        verify(pretRepository, times(1)).save(any(Pret.class));
        verify(exemplaireRepository, times(1)).save(exemplaire);
        verify(adherentRepository, times(1)).save(adherent);
        assertEquals(Exemplaire.StatutExemplaire.EN_PRET, exemplaire.getStatut());
        assertEquals(2, adherent.getQuotaRestant());
        assertEquals(1, pret.getIdPret());
    }

    @Test
    public void testPreterExemplaireAdherentNonExistant() {
        when(adherentRepository.findById(eq(1))).thenReturn(Optional.empty());
        PretException exception = assertThrows(PretException.class,
                () -> pretService.preterExemplaire(1, 1, "DOMICILE"));
        assertEquals("L'adhérent n'existe pas.", exception.getMessage());
 
 
    }






    

    @Test
    public void testPreterExemplaireQuotaDepasse() {
        Adherent adherent = new Adherent();
        adherent.setIdAdherent(1);
        adherent.setStatut(Adherent.StatutAdherent.ACTIF);
        adherent.setDateNaissance(LocalDate.of(2000, 1, 1));
        Profil profil = new Profil();
        profil.setQuotaPret(3);
        profil.setDureePret(7);
        profil.setTypeProfil(Profil.TypeProfil.ETUDIANT);
        adherent.setProfil(profil);
        adherent.setQuotaRestant(0);

        Abonnement abonnement = new Abonnement();
        abonnement.setStatut(Abonnement.StatutAbonnement.ACTIVE);
        abonnement.setDateDebut(LocalDate.now().minusDays(10));
        abonnement.setDateFin(LocalDate.now().plusDays(10));

        Exemplaire exemplaire = new Exemplaire();
        exemplaire.setIdExemplaire(1);
        exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);
        Livre livre = new Livre();
        livre.setRestrictionAge(0);
        livre.setProfesseurSeulement(false);
        exemplaire.setLivre(livre);

        when(adherentRepository.findById(eq(1))).thenReturn(Optional.of(adherent));
        when(abonnementRepository.findActiveAbonnementByAdherent(eq(1), any(LocalDate.class))).thenReturn(abonnement);
        when(exemplaireRepository.findById(eq(1))).thenReturn(Optional.of(exemplaire));
        when(pretRepository.countActivePretsByAdherent(eq(1))).thenReturn(3L);

        PretException exception = assertThrows(PretException.class,
                () -> pretService.preterExemplaire(1, 1, "DOMICILE"));
        assertEquals("L'adhérent a atteint son quota de prêts.", exception.getMessage());
    }

    @Test
    public void testRetournerExemplaireSuccess() {
        Adherent adherent = new Adherent();
        adherent.setIdAdherent(1);
        adherent.setQuotaRestant(2);
        Profil profil = new Profil();
        profil.setQuotaPret(3);
        adherent.setProfil(profil);

        Exemplaire exemplaire = new Exemplaire();
        exemplaire.setIdExemplaire(1);
        exemplaire.setStatut(Exemplaire.StatutExemplaire.EN_PRET);

        Pret pret = new Pret();
        pret.setIdPret(1);
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        pret.setDateRetourEffective(null);

        when(pretRepository.findById(eq(1))).thenReturn(Optional.of(pret));

        pretService.retournerExemplaire(1);

        verify(pretRepository, times(1)).save(pret);
        verify(exemplaireRepository, times(1)).save(exemplaire);
        verify(adherentRepository, times(1)).save(adherent);
        assertEquals(Exemplaire.StatutExemplaire.DISPONIBLE, exemplaire.getStatut());
        assertEquals(3, adherent.getQuotaRestant());
        assertEquals(LocalDateTime.now().getDayOfYear(), pret.getDateRetourEffective().getDayOfYear());
    }

    @Test
    public void testRetournerExemplairePretNonExistant() {
        when(pretRepository.findById(eq(1))).thenReturn(Optional.empty());
        PretException exception = assertThrows(PretException.class,
                () -> pretService.retournerExemplaire(1));
        assertEquals("Le prêt n'existe pas.", exception.getMessage());
    }

    @Test
    public void testRetournerExemplaireDejaRetourne() {
        Adherent adherent = new Adherent();
        adherent.setIdAdherent(1);
        adherent.setQuotaRestant(2);

        Exemplaire exemplaire = new Exemplaire();
        exemplaire.setIdExemplaire(1);
        exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);

        Pret pret = new Pret();
        pret.setIdPret(1);
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        pret.setDateRetourEffective(LocalDateTime.now());

        when(pretRepository.findById(eq(1))).thenReturn(Optional.of(pret));

        PretException exception = assertThrows(PretException.class,
                () -> pretService.retournerExemplaire(1));
        assertEquals("Le prêt a déjà été retourné.", exception.getMessage());
    }
}



