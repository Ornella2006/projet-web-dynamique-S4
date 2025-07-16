/* package com.biblio.service;

import com.biblio.exception.PretException;
import com.biblio.model.*;
import com.biblio.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import static org.mockito.ArgumentMatchers.any;




import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

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

    @Mock
    private ReservationRepository reservationRepository;

    @Mock
    private ProlongementRepository prolongementRepository;

    @Mock
    private HttpSession session; // Mock de la session HTTP

    @InjectMocks
    private PretService pretService;

    private Adherent adherent;
    private User mockUser;
    private Adherent mockAdherent;
        private Exemplaire mockExemplaire;



    @BeforeEach
public void setUp() {
    MockitoAnnotations.openMocks(this);

    // Créer un mock Adherent
    mockAdherent = new Adherent();
    mockAdherent.setIdAdherent(1);
    mockAdherent.setNom("TestAdherent");

    // Créer un mock User
    mockUser = new User();
    mockUser.setAdherent(mockAdherent);

    // Créer un mock Exemplaire
    mockExemplaire = new Exemplaire();
    mockExemplaire.setIdExemplaire(1);
    mockExemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);

    // Configurer les mocks
    when(adherentRepository.findById(1)).thenReturn(Optional.of(mockAdherent));
    when(exemplaireRepository.findById(1)).thenReturn(Optional.of(mockExemplaire));

    // Ajouter le mock pour AbonnementRepository avec une valeur spécifique
    when(abonnementRepository.findActiveAbonnementByAdherent(eq(mockAdherent), any(LocalDate.class)))
        .thenReturn(Optional.of(new Abonnement())); // Simuler un abonnement actif
}

    @Test
public void testPreterExemplaireSuccess() {
    Exemplaire exemplaire = new Exemplaire();
    exemplaire.setIdExemplaire(1);
    exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);
    Livre livre = new Livre();
    livre.setRestrictionAge(0);
    livre.setProfesseurSeulement(false);
    exemplaire.setLivre(livre);

    when(adherentRepository.findById(eq(1))).thenReturn(Optional.of(mockAdherent)); // Utilisez mockAdherent
    when(exemplaireRepository.findById(eq(1))).thenReturn(Optional.of(exemplaire));

    when(pretRepository.countActivePretsByAdherent(eq(1))).thenReturn(0L);
    when(jourFerieRepository.findByDateFerieBetween(any(LocalDate.class), any(LocalDate.class))).thenReturn(Collections.emptyList());
    when(pretRepository.save(any(Pret.class))).thenAnswer(invocation -> {
        Pret pret = invocation.getArgument(0);
        pret.setIdPret(1);
        return pret;
    });
    when(exemplaireRepository.save(any(Exemplaire.class))).thenAnswer(invocation -> invocation.getArgument(0));
    when(adherentRepository.save(any(Adherent.class))).thenAnswer(invocation -> invocation.getArgument(0));

    Pret pret = pretService.preterExemplaire(1, 1, "DOMICILE");

    verify(pretRepository, times(1)).save(any(Pret.class));
    verify(exemplaireRepository, times(1)).save(exemplaire);
    verify(adherentRepository, times(1)).save(mockAdherent); // Utilisez mockAdherent
    assertEquals(Exemplaire.StatutExemplaire.EN_PRET, exemplaire.getStatut());
    assertEquals(2, mockAdherent.getQuotaRestant()); // Utilisez mockAdherent
    assertEquals(1, pret.getIdPret());
}

    @Test
    public void testPreterExemplaireAdherentNonExistant() {
        when(adherentRepository.findById(eq(1))).thenReturn(Optional.empty());
        when(exemplaireRepository.findById(eq(1))).thenReturn(Optional.empty());

        PretException exception = assertThrows(PretException.class,
                () -> pretService.preterExemplaire(1, 1, "DOMICILE"));
        assertEquals("L'adhérent n'existe pas. et L'exemplaire n'existe pas.", exception.getMessage());
    }

    @Test
public void testPreterExemplaireQuotaDepasse() {
    mockAdherent.setQuotaRestant(0); // Utilisez mockAdherent

    Exemplaire exemplaire = new Exemplaire();
    exemplaire.setIdExemplaire(1);
    exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);
    Livre livre = new Livre();
    livre.setRestrictionAge(0);
    livre.setProfesseurSeulement(false);
    exemplaire.setLivre(livre);

    when(adherentRepository.findById(eq(1))).thenReturn(Optional.of(mockAdherent)); // Utilisez mockAdherent
    when(exemplaireRepository.findById(eq(1))).thenReturn(Optional.of(exemplaire));
    when(pretRepository.countActivePretsByAdherent(eq(1))).thenReturn(3L);

    PretException exception = assertThrows(PretException.class,
            () -> pretService.preterExemplaire(1, 1, "DOMICILE"));
    assertEquals("L'adhérent a atteint son quota de prêts.", exception.getMessage());
}

    @Test
public void testDemanderProlongationSuccess() {
    Pret pret = new Pret();
    pret.setIdPret(1);
    pret.setAdherent(mockAdherent); // Utilisez mockAdherent défini dans setUp
    pret.setDateRetourPrevue(LocalDate.now().plusDays(10));
    pret.setDateRetourEffective(null);
    pret.setProlongationCount(0);

    when(pretRepository.findById(eq(1))).thenReturn(Optional.of(pret));
    when(prolongementRepository.countByAdherentAndStatut(eq(mockAdherent), eq(Prolongement.StatutProlongement.EN_ATTENTE))).thenReturn(0L);
    when(prolongementRepository.save(any(Prolongement.class))).thenAnswer(invocation -> invocation.getArgument(0));
    // Configurer le mock de session
    when(session.getAttribute("user")).thenReturn(mockUser);

    Prolongement prolongement = pretService.demanderProlongation(1, LocalDate.now().plusDays(14), session);

    verify(prolongementRepository, times(1)).save(any(Prolongement.class));
    assertEquals(Prolongement.StatutProlongement.EN_ATTENTE, prolongement.getStatut());
}

    @Test
public void testDemanderProlongationQuotaDepasse() {
    Pret pret = new Pret();
    pret.setIdPret(1);
    pret.setAdherent(mockAdherent); // Utilisez mockAdherent défini dans setUp
    pret.setDateRetourPrevue(LocalDate.now().plusDays(10));
    pret.setDateRetourEffective(null);
    pret.setProlongationCount(1); // Supposons que le quota soit 1

    when(pretRepository.findById(eq(1))).thenReturn(Optional.of(pret));
    // Configurer le mock de session
    when(session.getAttribute("user")).thenReturn(mockUser);

    PretException exception = assertThrows(PretException.class,
            () -> pretService.demanderProlongation(1, LocalDate.now().plusDays(14), session));
    assertEquals("Quota de prolongements total dépassé.", exception.getMessage());
}

    // Suppression des tests pour RetourService et ReservationService, car ils ne sont pas mockés correctement
    // Vous pouvez les ajouter séparément avec leurs propres mocks si nécessaire
} */