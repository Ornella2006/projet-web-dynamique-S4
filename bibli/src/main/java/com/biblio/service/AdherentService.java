package com.biblio.service;

import com.biblio.model.Adherent;
import com.biblio.repository.PretRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdherentService {

    @Autowired
    private PretRepository pretRepository;

    public long countActiveLoansByAdherent(Adherent adherent) {
        return pretRepository.countActivePretsByAdherent(adherent.getIdAdherent());
    }

    // Autres méthodes si nécessaire
}