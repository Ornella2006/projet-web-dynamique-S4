package com.biblio.controller;

import java.time.LocalDate;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.biblio.model.Adherent;
import com.biblio.model.Profil;
import com.biblio.model.User;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.UserRepository;
import com.biblio.service.ReservationService;

@Controller
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private ReservationService reservationService;

    @GetMapping("/")
    public String showChoicePage() {
        return "choice";
    }

    @GetMapping("/login")
    public String showLoginPage(@RequestParam("role") String role, Model model) {
        model.addAttribute("role", role);
        return "login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam("email") String email,
                              @RequestParam("motDePasse") String motDePasse,
                              @RequestParam("role") String role,
                              Model model, HttpSession session) {
        try {
            User user = userRepository.findByEmail(email);
            if (user == null) {
                model.addAttribute("error", "Email incorrect.");
                model.addAttribute("role", role);
                return "login";
            }
            if (!user.getMotDePasse().equals(motDePasse)) {
                model.addAttribute("error", "Mot de passe incorrect.");
                model.addAttribute("role", role);
                return "login";
            }
            if (!user.getRole().toString().equals(role)) {
                model.addAttribute("error", "Rôle incorrect. Veuillez choisir le bon type de compte.");
                model.addAttribute("role", role);
                return "login";
            }
            session.setAttribute("user", user);
            if ("BIBLIOTHECAIRE".equals(role)) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/adherent/dashboard";
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Une erreur est survenue lors de la connexion. Veuillez réessayer.");
            model.addAttribute("role", role);
            return "login";
        }
    }

    @GetMapping("/admin/dashboard")
    public String showAdminDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.BIBLIOTHECAIRE) {
            return "redirect:/login?role=BIBLIOTHECAIRE";
        }
        return "adminDashboard";
    }

    @GetMapping("/adherent/dashboard")
    public String showAdherentDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.ADHERENT) {
            return "redirect:/login?role=ADHERENT";
        }
        return "adherentDashboard";
    }

    @GetMapping("/signin")
    public String showSigninPage(@RequestParam("role") String role, Model model) {
        model.addAttribute("role", role);
        return "signin";
    }

    @PostMapping("/signin")
    public String processSignin(@RequestParam("email") String email,
                                @RequestParam("motDePasse") String motDePasse,
                                @RequestParam("role") String role,
                                @RequestParam(value = "nom", required = false) String nom,
                                @RequestParam(value = "prenom", required = false) String prenom,
                                @RequestParam(value = "dateNaissance", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateNaissance,
                                @RequestParam(value = "idProfil", required = false) Integer idProfil,
                                Model model) {
        try {
            if (userRepository.findByEmail(email) != null) {
                model.addAttribute("error", "Cet email est déjà utilisé.");
                model.addAttribute("role", role);
                return "signin";
            }

            User user = new User();
            user.setEmail(email);
            user.setMotDePasse(motDePasse);
            user.setRole(User.Role.valueOf(role));

            if ("ADHERENT".equals(role)) {
                if (nom == null || nom.trim().isEmpty() || 
                    prenom == null || prenom.trim().isEmpty() || 
                    dateNaissance == null || 
                    idProfil == null) {
                    model.addAttribute("error", "Tous les champs sont requis pour les adhérents.");
                    model.addAttribute("role", role);
                    return "signin";
                }
                Adherent adherent = new Adherent();
                adherent.setNom(nom);
                adherent.setPrenom(prenom);
                adherent.setEmail(email);
                adherent.setDateNaissance(dateNaissance);
                adherent.setProfil(new Profil(idProfil));
                adherent.setStatut(Adherent.StatutAdherent.ACTIF);
                adherentRepository.save(adherent);
                user.setAdherent(adherent);
            }

            userRepository.save(user);
            return "redirect:/login?role=" + role;
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Une erreur est survenue lors de l'inscription. Veuillez vérifier vos informations.");
            model.addAttribute("role", role);
            return "signin";
        }
    }

   

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}
