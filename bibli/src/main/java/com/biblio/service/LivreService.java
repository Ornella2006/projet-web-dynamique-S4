package com.biblio.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.biblio.exception.PretException;
import com.biblio.model.Livre;
import com.biblio.repository.LivreRepository;

@Service
public class LivreService {

    @Autowired
    private LivreRepository livreRepository;

    @Transactional
    public void definirRestrictions(int idLivre, Integer restrictionAge, Boolean ENSEIGNANTSeulement) throws PretException {
        Livre livre = livreRepository.findById(idLivre)
                .orElseThrow(() -> new PretException("Livre inexistant."));
        
        if (restrictionAge != null && restrictionAge < 0) {
            throw new PretException("L'âge minimum doit être non négatif.");
        }

        livre.setRestrictionAge(restrictionAge != null ? restrictionAge : 0); // Valeur par défaut 0 si null
        livre.setENSEIGNANTSeulement(ENSEIGNANTSeulement != null ? ENSEIGNANTSeulement : false); // Valeur par défaut false si null
        livreRepository.save(livre);
    }
}