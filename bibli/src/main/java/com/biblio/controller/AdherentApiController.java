package com.biblio.controller;

import com.biblio.model.Adherent;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.AbonnementRepository;
import com.biblio.service.AdherentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/adherents")
public class AdherentApiController {

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private AdherentService adherentService;

    @GetMapping("/{idAdherent}/situation")
    public Map<String, Object> getAdherentSituation(@PathVariable int idAdherent) {
        Map<String, Object> response = new HashMap<>();

        // Récupérer l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new RuntimeException("Adhérent non trouvé"));

        // Vérifier l'abonnement
        LocalDate currentDate = LocalDate.now();
        boolean abonnementActif = abonnementRepository.findActiveAbonnementByAdherent(adherent, currentDate).isPresent();
        response.put("abonnement", abonnementActif ? "Actif" : "Expiré");

        // Calculer le quota de prêts à domicile
        long activeLoans = adherentService.countActiveLoansByAdherent(adherent);
        int quotaPret = adherent.getProfil().getQuotaPret(); // Assurez-vous que Profil a un getter pour quotaPret
        int quotaRestant = adherent.getQuotaRestant() != null ? adherent.getQuotaRestant() : quotaPret;
        response.put("quotaPret", Math.max(0, quotaRestant - (int)activeLoans));
        response.put("quotaMax", quotaPret);

        // Vérifier la sanction
        LocalDate dateFinSanction = adherent.getDateFinSanction();
        response.put("sanction", dateFinSanction != null && dateFinSanction.isAfter(currentDate)
                ? "Oui, jusqu'au " + dateFinSanction
                : "Non");

        return response;
    }
}