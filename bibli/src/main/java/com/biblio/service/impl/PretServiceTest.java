package com.biblio.service.impl;

import com.biblio.exception.BibliothequeException;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.Pret;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.PenaliteRepository;
import com.biblio.repository.PretRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.time.LocalDate;
import java.util.Collections;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class PretServiceTest {

    @Mock
    private AdherentRepository adherentRepository;

    @Mock
    private ExemplaireRepository exemplaireRepository;

    @Mock
    private PenaliteRepository penaliteRepository;

    @Mock
    private PretRepository pretRepository;

    @InjectMocks
    private PretServiceImpl pretService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testPreterLivre_Success() throws BibliothequeException {
        // Arrange
        Adherent adherent = new Adherent();
        adherent.setId(1L);
        adherent.setActif(true);
        adherent.setQuotaPret(3);
        adherent.setDateExpirationAbonnement(LocalDate.now().plusDays(10));

        Exemplaire exemplaire = new Exemplaire();
        exemplaire.setId(1L);
        exemplaire.setDisponible(true);

        when(adherentRepository.findById(1L)).thenReturn(Optional.of(adherent));
        when(exemplaireRepository.findById(1L)).thenReturn(Optional.of(exemplaire));
        when(penaliteRepository.findActivePenalitesByAdherentId(1L, LocalDate.now())).thenReturn(Collections.emptyList());
        when(pretRepository.save(any(Pret.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // Act
        Pret pret = pretService.preterLivre(1L, 1L, "MAISON");

        // Assert
        assertNotNull(pret);
        assertEquals(adherent, pret.getAdherent());
        assertEquals(exemplaire, pret.getExemplaire());
        assertEquals(2, adherent.getQuotaPret());
        assertFalse(exemplaire.isDisponible());
    }

    @Test
    void testPreterLivre_AdherentInactif() {
        // Arrange
        Adherent adherent = new Adherent();
        adherent.setId(1L);
        adherent.setActif(false);

        when(adherentRepository.findById(1L)).thenReturn(Optional.of(adherent));

        // Act & Assert
        BibliothequeException exception = assertThrows(BibliothequeException.class, () -> {
            pretService.preterLivre(1L, 1L, "MAISON");
        });
        assertEquals("Adhérent inactif.", exception.getMessage());
    }
}