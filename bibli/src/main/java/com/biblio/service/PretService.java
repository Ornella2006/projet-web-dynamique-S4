package com.biblio.service;

import com.biblio.exception.BibliothequeException;
import com.biblio.model.Pret;

public interface PretService {
    Pret preterLivre(Long adherentId, Long exemplaireId, String typePret) throws BibliothequeException;
}