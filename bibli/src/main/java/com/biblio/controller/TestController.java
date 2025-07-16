package com.biblio.controller;

import com.biblio.exception.PretException;
import com.biblio.model.Reservation;
import com.biblio.model.User;
import com.biblio.repository.ReservationRepository;
import com.biblio.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/test")
public class TestController {
    
    @Autowired
    private ReservationRepository reservationRepository;
    
    @Autowired
    private ReservationService reservationService;

    @GetMapping("/forceExpire")
    @ResponseBody
    public String forceExpire(@RequestParam int id) {
        Reservation r = reservationRepository.findById(id).orElse(null);
        if (r != null) {
            r.setDateExpiration(LocalDate.now().minusDays(1));
            reservationService.annulerReservationExpiree(r);
            return "Réservation " + id + " expirée forcée - Vérifiez la base de données";
        }
        return "Réservation non trouvée";
    }
}