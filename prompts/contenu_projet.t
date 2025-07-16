│   pom.xml :
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.biblio</groupId>
    <artifactId>bibli</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>jar</packaging> <!-- Changé de war à jar pour Spring Boot -->
    <name>gestion-bibliotheque</name>

    <properties>
        <java.version>17</java.version>
        <spring-boot.version>2.7.18</spring-boot.version>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    </properties>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.18</version>
        <relativePath/>   
    </parent>

    <dependencies>
        <!-- Spring Boot Starter Web (inclut Spring MVC et Tomcat embarqué) -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <!-- Spring Boot Starter Data JPA -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>

        <!-- MySQL Connector -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.28</version>
        </dependency>
        <!-- JSTL pour JSP -->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>jstl</artifactId>
            <!-- <version>1.2</version> -->
        </dependency>
        <!-- Tomcat embarqué pour supporter JSP -->
        <!-- <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
            <scope>provided</scope>
        </dependency> -->
        <!-- Tomcat Jasper pour le rendu des JSP -->
        <!-- <dependency>
            <groupId>org.apache.tomcat</groupId>
            <artifactId>tomcat-jasper</artifactId>
            <version>9.0.50</version>
        </dependency> -->
        <!-- Spring Boot Starter Test -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <!-- Mockito -->
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-core</artifactId>
            <version>5.14.0</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-junit-jupiter</artifactId>
            <version>5.14.0</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.tomcat.embed</groupId>
            <artifactId>tomcat-embed-jasper</artifactId>
        </dependency>
        <dependency>
            <groupId>net.bytebuddy</groupId>
            <artifactId>byte-buddy</artifactId>
            <version>1.15.7</version> <!-- Version compatible avec Java 17 -->
            <!-- <scope>test</scope> -->
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <!-- Plugin Spring Boot -->
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <version>2.7.18</version>
                <!-- <version>${spring-boot.version}</version> -->
                <executions>
                    <execution>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
            <!-- Maven Compiler Plugin -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.13.0</version>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                    <encoding>UTF-8</encoding>
                </configuration>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.2.5</version>
                <configuration>
                    <argLine>-Dnet.bytebuddy.experimental=true</argLine> <!-- Pour supporter les mocks inline -->
                </configuration>
                <dependencies>
                    <dependency>
                        <groupId>org.junit.jupiter</groupId>
                        <artifactId>junit-jupiter-engine</artifactId>
                        <version>5.10.2</version>
                    </dependency>
                </dependencies>
            </plugin>
        </plugins>
    </build>
</project>


├───src
│   ├───main
│   │   ├───java
│   │   │   └───com
│   │   │       └───biblio
│   │   │           │   Application.java :
package com.biblio;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = "com.biblio")
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

│   │   │           │
│   │   │           ├───controller
│   │   │           │       AuthController.java :
package com.biblio.controller;

import com.biblio.model.Adherent;
import com.biblio.model.Profil;
import com.biblio.model.User;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;

@Controller
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AdherentRepository adherentRepository;

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
│   │   │           │       PretController.java :
package com.biblio.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.biblio.model.Pret;
import com.biblio.service.PretService;

@Controller
public class PretController {

    @Autowired
    private PretService pretService;

    @GetMapping("/admin/pret")
    public String showPretForm(Model model) {
        model.addAttribute("typesPret", new String[]{"DOMICILE", "SUR_PLACE"});
        return "pretForm";
    }

    @PostMapping("/admin/pret")
    public String preterExemplaire(@RequestParam("adherentId") Integer adherentId,
                                   @RequestParam("exemplaireId") Integer exemplaireId,
                                   @RequestParam("typePret") String typePret,
                                   Model model) {
        try {
            System.out.println("Début preterExemplaire: idAdherent=" + adherentId + ", idExemplaire=" + exemplaireId + ", typePret=" + typePret);
            Pret pret = pretService.preterExemplaire(adherentId, exemplaireId, typePret);
            model.addAttribute("message", "Prêt enregistré avec succès. ID du prêt: " + pret.getIdPret());
            return "pretForm";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "pretForm";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Une erreur inattendue est survenue lors de l'enregistrement du prêt.");
            return "pretForm";
        }
    }
}

│   │   │           │       RetourController.java :
package com.biblio.controller;





import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.biblio.exception.PretException;
import com.biblio.service.RetourService;

@Controller
public class RetourController {

    @Autowired
    private RetourService retourService;

    @GetMapping("/admin/retour")
    public String showRetourForm() {
   
   
        return "retourForm";
    }



    @PostMapping("/admin/retour")
    public String retournerExemplaire(@RequestParam("idPret") Integer idPret, Model model) {
        try {
            retourService.retournerExemplaire(idPret);
            model.addAttribute("message", "Prêt retourné avec succès. ID du prêt: " + idPret);
            return "retourForm";
        } catch (PretException e) {
            model.addAttribute("error", e.getMessage());
            return "retourForm";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Une erreur inattendue est survenue lors du retour du prêt.");
            return "retourForm";
        }
    }
}

│   │   │           │
│   │   │           ├───exception
│   │   │           │       PretException.java :
package com.biblio.exception;

public class PretException extends RuntimeException {
    public PretException(String message) {
        super(message);
    }
}
│   │   │           │
│   │   │           ├───model
│   │   │           │       Abonnement.java :
package com.biblio.exception;

public class PretException extends RuntimeException {
    public PretException(String message) {
        super(message);
    }
}

│   │   │           │       Adherent.java :
package com.biblio.model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "Adherent")
public class Adherent {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adherent")
    private int idAdherent;

    @ManyToOne
    @JoinColumn(name = "id_profil", nullable = false)
    private Profil profil;

    @Column(name = "nom", nullable = false)
    private String nom;

    @Column(name = "prenom", nullable = false)
    private String prenom;

    @Column(name = "email", unique = true)
    private String email;

    @Column(name = "telephone")
    private String telephone;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut")
    private StatutAdherent statut;

    @Column(name = "date_naissance", nullable = false)
    private LocalDate dateNaissance;

    @Column(name = "quotat_restant", nullable = true)
    private Integer quotaRestant;

    public Integer getQuotaRestant() {
        return quotaRestant;
    }

    public void setQuotaRestant(Integer quotaRestant) {
        this.quotaRestant = quotaRestant;
    }

    public enum StatutAdherent {
        ACTIF, INACTIF, SANCTIONNE
    }


    // Constructeurs
    public Adherent() {}

    public Adherent(Profil profil, String nom, String prenom, String email, String telephone, StatutAdherent statut, LocalDate dateNaissance) {
        this.profil = profil;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.telephone = telephone;
        this.statut = statut;
        this.dateNaissance = dateNaissance;
    }

    // Getters et Setters
    public int getIdAdherent() {
        return idAdherent;
    }

    public void setIdAdherent(int idAdherent) {
        this.idAdherent = idAdherent;
    }

    public Profil getProfil() {
        return profil;
    }

    public void setProfil(Profil profil) {
        this.profil = profil;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public StatutAdherent getStatut() {
        return statut;
    }

    public void setStatut(StatutAdherent statut) {
        this.statut = statut;
    }

    public LocalDate getDateNaissance() {
        return dateNaissance;
    }

    public void setDateNaissance(LocalDate dateNaissance) {
        this.dateNaissance = dateNaissance;
    }

    
}
 
│   │   │           │       Exemplaire.java :
package com.biblio.model;

import javax.persistence.*;

@Entity
@Table(name = "Exemplaire")
public class Exemplaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idExemplaire;

    @ManyToOne
    @JoinColumn(name = "id_livre", nullable = false)
    private Livre livre;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private EtatExemplaire etat = EtatExemplaire.BON;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutExemplaire statut = StatutExemplaire.DISPONIBLE;

    public enum EtatExemplaire {
        BON, ABIME, PERDU
    }

    public enum StatutExemplaire {
        DISPONIBLE, EN_PRET, RESERVE, LECTURE_SUR_PLACE
    }

    // Getters and Setters
    public int getIdExemplaire() { return idExemplaire; }
    public void setIdExemplaire(int idExemplaire) { this.idExemplaire = idExemplaire; }
    public Livre getLivre() { return livre; }
    public void setLivre(Livre livre) { this.livre = livre; }
    public EtatExemplaire getEtat() { return etat; }
    public void setEtat(EtatExemplaire etat) { this.etat = etat; }
    public StatutExemplaire getStatut() { return statut; }
    public void setStatut(StatutExemplaire statut) { this.statut = statut; }
}

│   │   │           │       JourFerie.java :
package com.biblio.model;

import java.time.LocalDate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "jour_ferie") // Spécifie le nom exact de la table
public class JourFerie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_jourferie")
    private int idJourFerie;

    @Column(name = "date_ferie", nullable = false, unique = true)
    private LocalDate dateFerie;

    @Column(name = "description")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "regle_rendu")
    private RegleRendu regleRendu;

    public enum RegleRendu {
        AVANT, APRES
    }

    // Constructeurs
    public JourFerie() {}

    public JourFerie(LocalDate dateFerie, String description, RegleRendu regleRendu) {
        this.dateFerie = dateFerie;
        this.description = description;
        this.regleRendu = regleRendu;
    }

    // Getters et Setters
    public int getIdJourFerie() {
        return idJourFerie;
    }

    public void setIdJourFerie(int idJourFerie) {
        this.idJourFerie = idJourFerie;
    }

    public LocalDate getDateFerie() {
        return dateFerie;
    }

    public void setDateFerie(LocalDate dateFerie) {
        this.dateFerie = dateFerie;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public RegleRendu getRegleRendu() {
        return regleRendu;
    }

    public void setRegleRendu(RegleRendu regleRendu) {
        this.regleRendu = regleRendu;
    }
}

│   │   │           │       jour_ferie.java :
package com.biblio.model;

import java.time.LocalDate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "jour_ferie") // Spécifie le nom exact de la table
public class jour_ferie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_jourferie")
    private int idJourFerie;

    @Column(name = "date_ferie", nullable = false, unique = true)
    private LocalDate dateFerie;

    @Column(name = "description")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "regle_rendu")
    private RegleRendu regleRendu;

    public enum RegleRendu {
        AVANT, APRES
    }

    // Constructeurs
    public jour_ferie() {}

    public jour_ferie(LocalDate dateFerie, String description, RegleRendu regleRendu) {
        this.dateFerie = dateFerie;
        this.description = description;
        this.regleRendu = regleRendu;
    }

    // Getters et Setters
    public int getIdJourFerie() {
        return idJourFerie;
    }

    public void setIdJourFerie(int idJourFerie) {
        this.idJourFerie = idJourFerie;
    }

    public LocalDate getDateFerie() {
        return dateFerie;
    }

    public void setDateFerie(LocalDate dateFerie) {
        this.dateFerie = dateFerie;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public RegleRendu getRegleRendu() {
        return regleRendu;
    }

    public void setRegleRendu(RegleRendu regleRendu) {
        this.regleRendu = regleRendu;
    }
}
│   │   │           │       Livre.java :
package com.biblio.model;

import javax.persistence.*;

@Entity
@Table(name = "Livre")
public class Livre {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idLivre;

    @Column(nullable = false)
    private String titre;

    private String auteur;

    private String editeur;

    private Integer anneePublication;

    private String genre;

    @Column(unique = true)
    private String isbn;

    private int restrictionAge = 0;

    private boolean professeurSeulement = false;

    // Getters and Setters
    public int getIdLivre() { return idLivre; }
    public void setIdLivre(int idLivre) { this.idLivre = idLivre; }
    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }
    public String getAuteur() { return auteur; }
    public void setAuteur(String auteur) { this.auteur = auteur; }
    public String getEditeur() { return editeur; }
    public void setEditeur(String editeur) { this.editeur = editeur; }
    public Integer getAnneePublication() { return anneePublication; }
    public void setAnneePublication(Integer anneePublication) { this.anneePublication = anneePublication; }
    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public int getRestrictionAge() { return restrictionAge; }
    public void setRestrictionAge(int restrictionAge) { this.restrictionAge = restrictionAge; }
    public boolean isProfesseurSeulement() { return professeurSeulement; }
    public void setProfesseurSeulement(boolean professeurSeulement) { this.professeurSeulement = professeurSeulement; }
}
│   │   │           │       Pret.java :
package com.biblio.model;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "Pret")
public class Pret {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idPret;

    @ManyToOne
    @JoinColumn(name = "id_exemplaire", nullable = false)
    private Exemplaire exemplaire;

    @ManyToOne
    @JoinColumn(name = "id_adherent", nullable = false)
    private Adherent adherent;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TypePret typePret;

    @Column(nullable = false)
    private LocalDateTime datePret;

    @Column(nullable = false)
    private LocalDateTime dateRetourPrevue;

    private LocalDateTime dateRetourEffective;

    @Column(nullable = false)
    private int prolongationCount = 0;

    public enum TypePret {
        DOMICILE, SUR_PLACE
    }

    // Getters and Setters
    public int getIdPret() { return idPret; }
    public void setIdPret(int idPret) { this.idPret = idPret; }
    public Exemplaire getExemplaire() { return exemplaire; }
    public void setExemplaire(Exemplaire exemplaire) { this.exemplaire = exemplaire; }
    public Adherent getAdherent() { return adherent; }
    public void setAdherent(Adherent adherent) { this.adherent = adherent; }
    public TypePret getTypePret() { return typePret; }
    public void setTypePret(TypePret typePret) { this.typePret = typePret; }
    public LocalDateTime getDatePret() { return datePret; }
    public void setDatePret(LocalDateTime datePret) { this.datePret = datePret; }
    public LocalDateTime getDateRetourPrevue() { return dateRetourPrevue; }
    public void setDateRetourPrevue(LocalDateTime dateRetourPrevue) { this.dateRetourPrevue = dateRetourPrevue; }
    public LocalDateTime getDateRetourEffective() { return dateRetourEffective; }
    public void setDateRetourEffective(LocalDateTime dateRetourEffective) { this.dateRetourEffective = dateRetourEffective; }
    public int getProlongationCount() { return prolongationCount; }
    public void setProlongationCount(int prolongationCount) { this.prolongationCount = prolongationCount; }
}

│   │   │           │       Profil.java :
package com.biblio.model;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "Pret")
public class Pret {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idPret;

    @ManyToOne
    @JoinColumn(name = "id_exemplaire", nullable = false)
    private Exemplaire exemplaire;

    @ManyToOne
    @JoinColumn(name = "id_adherent", nullable = false)
    private Adherent adherent;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TypePret typePret;

    @Column(nullable = false)
    private LocalDateTime datePret;

    @Column(nullable = false)
    private LocalDateTime dateRetourPrevue;

    private LocalDateTime dateRetourEffective;

    @Column(nullable = false)
    private int prolongationCount = 0;

    public enum TypePret {
        DOMICILE, SUR_PLACE
    }

    // Getters and Setters
    public int getIdPret() { return idPret; }
    public void setIdPret(int idPret) { this.idPret = idPret; }
    public Exemplaire getExemplaire() { return exemplaire; }
    public void setExemplaire(Exemplaire exemplaire) { this.exemplaire = exemplaire; }
    public Adherent getAdherent() { return adherent; }
    public void setAdherent(Adherent adherent) { this.adherent = adherent; }
    public TypePret getTypePret() { return typePret; }
    public void setTypePret(TypePret typePret) { this.typePret = typePret; }
    public LocalDateTime getDatePret() { return datePret; }
    public void setDatePret(LocalDateTime datePret) { this.datePret = datePret; }
    public LocalDateTime getDateRetourPrevue() { return dateRetourPrevue; }
    public void setDateRetourPrevue(LocalDateTime dateRetourPrevue) { this.dateRetourPrevue = dateRetourPrevue; }
    public LocalDateTime getDateRetourEffective() { return dateRetourEffective; }
    public void setDateRetourEffective(LocalDateTime dateRetourEffective) { this.dateRetourEffective = dateRetourEffective; }
    public int getProlongationCount() { return prolongationCount; }
    public void setProlongationCount(int prolongationCount) { this.prolongationCount = prolongationCount; }
}

│   │   │           │       User.java :
package com.biblio.model;

import javax.persistence.*;

@Entity
@Table(name = "User")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_user")
    private int idUser;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "mot_de_passe", nullable = false)
    private String motDePasse;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false)
    private Role role;

    @ManyToOne
    @JoinColumn(name = "id_adherent")
    private Adherent adherent;

    public enum Role {
        ADHERENT, BIBLIOTHECAIRE
    }

    // Constructeurs
    public User() {}

    public User(String email, String motDePasse, Role role, Adherent adherent) {
        this.email = email;
        this.motDePasse = motDePasse;
        this.role = role;
        this.adherent = adherent;
    }

    // Getters et Setters
    public int getIdUser() {
        return idUser;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMotDePasse() {
        return motDePasse;
    }

    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Adherent getAdherent() {
        return adherent;
    }

    public void setAdherent(Adherent adherent) {
        this.adherent = adherent;
    }
}
│   │   │           │
│   │   │           ├───repository
│   │   │           │       AbonnementRepository.java :
package com.biblio.model;

import javax.persistence.*;

@Entity
@Table(name = "User")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_user")
    private int idUser;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "mot_de_passe", nullable = false)
    private String motDePasse;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false)
    private Role role;

    @ManyToOne
    @JoinColumn(name = "id_adherent")
    private Adherent adherent;

    public enum Role {
        ADHERENT, BIBLIOTHECAIRE
    }

    // Constructeurs
    public User() {}

    public User(String email, String motDePasse, Role role, Adherent adherent) {
        this.email = email;
        this.motDePasse = motDePasse;
        this.role = role;
        this.adherent = adherent;
    }

    // Getters et Setters
    public int getIdUser() {
        return idUser;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMotDePasse() {
        return motDePasse;
    }

    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Adherent getAdherent() {
        return adherent;
    }

    public void setAdherent(Adherent adherent) {
        this.adherent = adherent;
    }
}
│   │   │           │       AdherentRepository.java :
package com.biblio.repository;

import com.biblio.model.Adherent;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdherentRepository extends JpaRepository<Adherent, Integer> {
}
│   │   │           │       ExemplaireRepository.java :
package com.biblio.repository;

import com.biblio.model.Adherent;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdherentRepository extends JpaRepository<Adherent, Integer> {
}
│   │   │           │       JourFerieRepository.java :
package com.biblio.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.biblio.model.JourFerie;

public interface JourFerieRepository extends JpaRepository<JourFerie, Integer> {
    List<JourFerie> findByDateFerieBetween(LocalDate startDate, LocalDate endDate);
}
│   │   │           │       jour_ferieRepository.java :
package com.biblio.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.biblio.model.jour_ferie;

public interface jour_ferieRepository extends JpaRepository<jour_ferie, Integer> {
    List<jour_ferie> findByDateFerieBetween(LocalDate startDate, LocalDate endDate);
}

│   │   │           │       PretRepository.java :
package com.biblio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.biblio.model.Pret;

public interface PretRepository extends JpaRepository<Pret, Integer> {
    @Query("SELECT COUNT(p) FROM Pret p WHERE p.adherent.idAdherent = :idAdherent AND p.dateRetourEffective IS NULL")
    long countActivePretsByAdherent(@Param("idAdherent") int idAdherent);
}

│   │   │           │       UserRepository.java :
package com.biblio.repository;

import com.biblio.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Integer> {
    User findByEmail(String email);
}
│   │   │           │
│   │   │           └───service
│   │   │                   AbonnementService.java :
package com.biblio.service;

import java.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.biblio.exception.PretException;
import com.biblio.model.Abonnement;
import com.biblio.model.Adherent;
import com.biblio.repository.AbonnementRepository;
import com.biblio.repository.AdherentRepository;

@Service
public class AbonnementService {

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private AdherentRepository adherentRepository;

    @Transactional
    public Abonnement activerAbonnement(int idAdherent, LocalDate dateDebut, LocalDate dateFin, double montant) {
        System.out.println("Début activerAbonnement: idAdherent=" + idAdherent + ", dateDebut=" + dateDebut + ", dateFin=" + dateFin);

        // Valider l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));

        // Créer l'abonnement
        Abonnement abonnement = new Abonnement();
        abonnement.setAdherent(adherent);
        abonnement.setDateDebut(dateDebut);
        abonnement.setDateFin(dateFin);
        abonnement.setMontant(montant);
        abonnement.setStatut(Abonnement.StatutAbonnement.ACTIVE);

        // Réinitialiser le quota restant
        adherent.setQuotaRestant(adherent.getProfil().getQuotaPret());
        adherentRepository.save(adherent);

        // Enregistrer l'abonnement
        try {
            abonnementRepository.save(abonnement);
            System.out.println("Abonnement activé: " + abonnement.getIdAbonnement() + ", Quota restant réinitialisé: " + adherent.getQuotaRestant());
            return abonnement;
        } catch (Exception e) {
            e.printStackTrace();
            throw new PretException("Erreur lors de l'activation de l'abonnement: " + e.getMessage());
        }
    }
}
│   │   │                   PretService.java :
package com.biblio.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.DayOfWeek;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.biblio.exception.PretException;
import com.biblio.model.Abonnement;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.JourFerie;
import com.biblio.model.Pret;
import com.biblio.model.Profil;
import com.biblio.repository.AbonnementRepository;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.JourFerieRepository;
import com.biblio.repository.PretRepository;

@Service
public class PretService {

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private JourFerieRepository jourFerieRepository;

    @Transactional
    public Pret preterExemplaire(int idAdherent, int idExemplaire, String typePret) {
        System.out.println("Début preterExemplaire: idAdherent=" + idAdherent + ", idExemplaire=" + idExemplaire + ", typePret=" + typePret);

        // Valider l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new PretException("L'adhérent n'existe pas."));
        System.out.println("Adhérent trouvé: " + adherent.getIdAdherent() + ", Statut: " + adherent.getStatut());

        // Vérifier le statut de l'adhérent
        if (adherent.getStatut() == Adherent.StatutAdherent.SANCTIONNE) {
            throw new PretException("L'adhérent est sous sanction.");
        }

        // Vérifier l'abonnement actif
        LocalDate currentDate = LocalDate.now();
        Abonnement abonnement = abonnementRepository.findActiveAbonnementByAdherent(idAdherent, currentDate);
        if (abonnement == null) {
            throw new PretException("Aucun abonnement actif trouvé pour cet adhérent.");
        }
        System.out.println("Abonnement trouvé: " + abonnement.getIdAbonnement());

        // Vérifier l'exemplaire
        Exemplaire exemplaire = exemplaireRepository.findById(idExemplaire)
                .orElseThrow(() -> new PretException("L'exemplaire n'existe pas."));
        System.out.println("Exemplaire trouvé: " + exemplaire.getIdExemplaire() + ", Statut: " + exemplaire.getStatut());
        if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
            throw new PretException("L'exemplaire n'est pas disponible.");
        }

        // Vérifier la restriction d'âge
        int age = LocalDate.now().getYear() - adherent.getDateNaissance().getYear();
        if (exemplaire.getLivre().getRestrictionAge() > age) {
            throw new PretException("L'adhérent ne satisfait pas à la restriction d'âge.");
        }

        // Vérifier la restriction professeur
        if (exemplaire.getLivre().isProfesseurSeulement() && adherent.getProfil().getTypeProfil() != Profil.TypeProfil.PROFESSEUR) {
            throw new PretException("Livre réservé aux professeurs.");
        }

        // Vérifier le quota de prêts
        long activePrets = pretRepository.countActivePretsByAdherent(idAdherent);
        System.out.println("Nombre de prêts actifs: " + activePrets + ", Quota: " + adherent.getProfil().getQuotaPret()+ ", Quota restant: " + adherent.getQuotaRestant());
        if (activePrets >= adherent.getProfil().getQuotaPret() || adherent.getQuotaRestant() <= 0) {
            throw new PretException("L'adhérent a atteint son quota de prêts.");
        }
        adherent.setQuotaRestant(adherent.getQuotaRestant() - 1);
        adherentRepository.save(adherent);  

        // Calculer la date de retour prévue
        LocalDateTime datePret = LocalDateTime.now();
        LocalDateTime dateRetourPrevue = datePret.plusDays(adherent.getProfil().getDureePret());
        System.out.println("Date prêt: " + datePret + ", Date retour prévue: " + dateRetourPrevue);

        // Vérifier les jours fériés
        List<JourFerie> joursFeries = jourFerieRepository.findByDateFerieBetween(
                datePret.toLocalDate(), dateRetourPrevue.toLocalDate());
        for (JourFerie jour : joursFeries) {
            System.out.println("Jour férié trouvé: " + jour.getDateFerie());
            if (jour.getRegleRendu() == JourFerie.RegleRendu.AVANT
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.minusDays(1);
            } else if (jour.getRegleRendu() == JourFerie.RegleRendu.APRES
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.plusDays(1);
            }
        }

        while (dateRetourPrevue.getDayOfWeek() == DayOfWeek.SATURDAY || 
               dateRetourPrevue.getDayOfWeek() == DayOfWeek.SUNDAY) {
            System.out.println("Date retour prévue tombe un week-end: " + dateRetourPrevue);
            dateRetourPrevue = dateRetourPrevue.minusDays(1); // Avancer au vendredi précédent
        }

        //si je veux que ça soit repousser au lundi (apres au lieu d'avant)
        /* while (dateRetourPrevue.getDayOfWeek() == DayOfWeek.SATURDAY || 
            dateRetourPrevue.getDayOfWeek() == DayOfWeek.SUNDAY) {
            System.out.println("Date retour prévue tombe un week-end: " + dateRetourPrevue);
            dateRetourPrevue = dateRetourPrevue.plusDays(1); // Repousser au lundi suivant
        } */

        joursFeries = jourFerieRepository.findByDateFerieBetween(
                datePret.toLocalDate(), dateRetourPrevue.toLocalDate());
        for (JourFerie jour : joursFeries) {
            System.out.println("Jour férié trouvé après ajustement: " + jour.getDateFerie());
            if (jour.getRegleRendu() == JourFerie.RegleRendu.AVANT
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.minusDays(1);
            } else if (jour.getRegleRendu() == JourFerie.RegleRendu.APRES
                    && jour.getDateFerie().isEqual(dateRetourPrevue.toLocalDate())) {
                dateRetourPrevue = dateRetourPrevue.plusDays(1);
            }
        }

        System.out.println("Date retour prévue ajustée: " + dateRetourPrevue);

        // Créer le prêt
        Pret pret = new Pret();
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        try {
            pret.setTypePret(Pret.TypePret.valueOf(typePret.replace(" ", "_").toUpperCase()));
        } catch (IllegalArgumentException e) {
            System.out.println("Erreur typePret: " + typePret);
            throw new PretException("Type de prêt invalide: " + typePret);
        }
        pret.setDatePret(datePret);
        pret.setDateRetourPrevue(dateRetourPrevue);

        // Mettre à jour le statut de l'exemplaire
        exemplaire.setStatut(Pret.TypePret.valueOf(typePret.replace(" ", "_").toUpperCase()) == Pret.TypePret.DOMICILE
                ? Exemplaire.StatutExemplaire.EN_PRET
                : Exemplaire.StatutExemplaire.LECTURE_SUR_PLACE);
        System.out.println("Nouveau statut exemplaire: " + exemplaire.getStatut());

        // Enregistrer les changements
        try {
            exemplaireRepository.save(exemplaire);
            System.out.println("Exemplaire enregistré: " + exemplaire.getIdExemplaire());
            pretRepository.save(pret);
            System.out.println("Prêt enregistré: " + pret.getIdPret());
            return pret; // Retourner l'objet Pret
        } catch (Exception e) {
            e.printStackTrace();
            throw new PretException("Erreur lors de l'enregistrement du prêt: " + e.getMessage());
        }
    }

   
}
│   │   │                   RetourService.java :
package com.biblio.service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.biblio.exception.PretException;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.Pret;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.PretRepository;

@Service
public class RetourService {

    @Autowired
    private PretRepository pretRepository;

    
    @Autowired
    private ExemplaireRepository exemplaireRepository;

     @Autowired
    private AdherentRepository adherentRepository;



    @Transactional
    public void retournerExemplaire(int idPret) {
        System.out.println("Début retournerExemplaire: idPret=" + idPret);

        // Trouver le prêt
        Pret pret = pretRepository.findById(idPret)
                .orElseThrow(() -> new PretException("Le prêt n'existe pas."));
        if (pret.getDateRetourEffective() != null) {
            throw new PretException("Le prêt a déjà été retourné.");
        }

        // Mettre à jour la date de retour effective
        pret.setDateRetourEffective(LocalDateTime.now());

        // Mettre à jour le statut de l'exemplaire
        Exemplaire exemplaire = pret.getExemplaire();
        exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);

        // Incrémenter le quota restant de l'adhérent
        Adherent adherent = pret.getAdherent();
        adherent.setQuotaRestant(adherent.getQuotaRestant() + 1);

        // Enregistrer les changements
        try {
            pretRepository.save(pret);
            exemplaireRepository.save(exemplaire);
            adherentRepository.save(adherent);
            System.out.println("Prêt retourné: " + pret.getIdPret() + ", Exemplaire: " + exemplaire.getIdExemplaire() + ", Quota restant: " + adherent.getQuotaRestant());
        } catch (Exception e) {
            e.printStackTrace();
            throw new PretException("Erreur lors du retour du prêt: " + e.getMessage());
        }
    }
    
}

│   │   │
│   │   ├───resources
│   │   │   │   application.properties :
     spring.datasource.url=jdbc:mysql://localhost:3306/gestion_bibliotheque?useSSL=false&serverTimezone=UTC
     spring.datasource.username=root
     spring.datasource.password=
     spring.jpa.hibernate.ddl-auto=update
     spring.jpa.show-sql=true
     spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
     spring.mvc.view.prefix=/WEB-INF/views/
     spring.mvc.view.suffix=.jsp
     server.port=8081
     spring.jpa.open-in-view=false
     logging.level.org.hibernate.SQL=DEBUG
     logging.level.org.hibernate.type.descriptor.sql=TRACE
│   │   │   │
│   │   │   └───templates
│   │   │          rien
│   │   │
│   │   └───webapp
            |   css
                   adherent.css :
                   body {
    background: url('https://images.unsplash.com/photo-1512820790803-83ca1980f6b9') no-repeat center center fixed;
    background-size: cover;
    min-height: 100vh;
    margin: 0;
    font-family: 'Georgia', serif;
}
.sidebar {
    position: fixed;
    top: 0;
    left: 0;
    height: 100%;
    width: 250px;
    background-color: rgba(139, 69, 19, 0.95);
    padding-top: 20px;
    color: white;
}
.sidebar a {
    color: white;
    padding: 15px;
    display: block;
    text-decoration: none;
    transition: background-color 0.3s;
}
.sidebar a:hover {
    background-color: #A0522D;
}
.content {
    margin-left: 270px;
    padding: 20px;
}
.card {
    background-color: rgba(255, 255, 255, 0.95);
    border: 1px solid #8B4513;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    transition: transform 0.3s;
    text-align: center !important;
}
.card:hover {
    transform: scale(1.05);
}
.card-title {
    color: #8B4513;
    font-weight: bold;
}
.card-text {
    color: #333;
}
.btn-custom {
    background-color: #8B4513;
    color: white;
    border: none;
}
.btn-custom:hover {
    background-color: #A0522D;
}

                   admin.css : 
                   body {
    background: url('https://images.unsplash.com/photo-1512820790803-83ca1980f6b9') no-repeat center center fixed;
    background-size: cover;
    min-height: 100vh;
    margin: 0;
    font-family: 'Georgia', serif;
}
.sidebar {
    position: fixed;
    top: 0;
    left: 0;
    height: 100%;
    width: 250px;
    background-color: rgba(139, 69, 19, 0.95);
    padding-top: 20px;
    color: white;
}
.sidebar a {
    color: white;
    padding: 15px;
    display: block;
    text-decoration: none;
    transition: background-color 0.3s;
}
.sidebar a:hover {
    background-color: #A0522D;
}
.content {
    margin-left: 270px;
    padding: 20px;
}
.card {
    background-color: rgba(255, 255, 255, 0.95);
    border: 1px solid #8B4513;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    transition: transform 0.3s;
    text-align: center !important;
}
.card:hover {
    transform: scale(1.05);
}
.card-title {
    color: #8B4513;
    font-weight: bold;
}
.card-text {
    color: #333;
}
.btn-custom {
    background-color: #8B4513;
    color: white;
    border: none;
}
.btn-custom:hover {
    background-color: #A0522D;
}
.form-container {
    background-color: rgba(255, 255, 255, 0.95);
    padding: 2rem;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    max-width: 500px;
    margin: auto;
}
.error {
    color: red;
    font-size: 0.9em;
    margin-top: 10px;
}
.success {
    color: green;
    font-size: 0.9em;
    margin-top: 10px;
}
h2 {
    color: #8B4513;
    font-weight: bold;
    text-align: center;
}

                   public.css :
                   body {
    background: url('https://images.unsplash.com/photo-1512820790803-83ca1980f6b9') no-repeat center center fixed;
    background-size: cover;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 0;
    font-family: 'Georgia', serif;
}
.card {
    background-color: rgba(255, 255, 255, 0.95);
    border: 1px solid #8B4513;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    transition: transform 0.3s;
}
.card:hover {
    transform: scale(1.05);
}
.card-title {
    color: #8B4513;
    font-weight: bold;
}
.card-text {
    color: #333;
}
.btn-custom {
    background-color: #8B4513;
    color: white;
    border: none;
}
.btn-custom:hover {
    background-color: #A0522D;
}
.login-container, .signin-container {
    background-color: rgba(255, 255, 255, 0.95);
    padding: 2rem;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    width: 100%;
    max-width: 400px;
}
.error {
    color: red;
    font-size: 0.9em;
}

│   │       └───WEB-INF
│   │           └───views
                        fragments
                                sidebar-admin.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
    <h3 class="text-center mb-4">Menu Bibliothécaire</h3>
    <a href="/admin/pret">Gérer les Prêts</a>
    <a href="/admin/retour">Retour des Prêts</a>
    <a href="/admin/reservation">Gérer les Réservations</a>
    <a href="/admin/livre">Gérer les Livres</a>
    <a href="/admin/exemplaire">Gérer les Exemplaires</a>
    <a href="/admin/adherent">Gérer les Adhérents</a>
    <a href="/logout" class="btn btn-custom mt-3 ms-3">Déconnexion</a>
</div>

                                sidebar-adherent.jsp :
                                <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
    <h3 class="text-center mb-4">Menu Adhérent</h3>
    <a href="/adherent/prets">Voir mes Prêts</a>
    <a href="/adherent/reservations">Voir mes Réservations</a>
    <a href="/adherent/profil">Mon Profil</a>
    <a href="/logout" class="btn btn-custom mt-3 ms-3">Déconnexion</a>
</div>

   │                   adherentDashboard.jsp : 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tableau de Bord - Bibliothécaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/admin.css" rel="stylesheet">
</head>
<body>
    <%@ include file="fragments/sidebar-admin.jsp" %>
    <div class="content">
        <div class="container">
            <h1 class="text-center mb-4" style="color: white; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);">Tableau de Bord Bibliothécaire</h1>
           <div class="row">
                <div class="col-md-6 mx-auto">
                    <div class="card p-4 mb-4">
                        <div class="text-center">
                            <h3 class="card-title">Bienvenue, Bibliothécaire</h3>
                            <p class="card-text">Utilisez le menu à gauche pour gérer les prêts, réservations, livres, exemplaires et adhérents.</p>
                        </div>
                    </div>
                </div>
            </div>
            ${content}
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

│   │                   adminDashboard.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tableau de Bord - Adhérent</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/adherent.css" rel="stylesheet">
</head>
<body>
    <%@ include file="fragments/sidebar-adherent.jsp" %>
    <div class="content">
        <div class="container">
            <h1 class="text-center mb-4" style="color: white; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);">Tableau de Bord Adhérent</h1>
            <div class="row">
                <div class="col-md-6 mx-auto">
                    <div class="card p-4 mb-4 text-center">
                        <h3 class="card-title">Bienvenue, Adhérent</h3>
                        <p class="card-text">Utilisez le menu à gauche pour consulter vos prêts, réservations ou votre profil.</p>
                    </div>
                </div>
            </div>
            ${content}
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

│   │                   choice.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bibliothèque - Choix du Profil</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/public.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h1 class="text-center mb-5" style="color: white; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);">Bienvenue à la Bibliothèque</h1>
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card text-center p-4 m-2">
                    <h3 class="card-title">Accéder en tant qu'Adhérent</h3>
                    <p class="card-text">Connectez-vous pour consulter vos prêts, etc.</p>
                    <a href="/login?role=ADHERENT" class="btn btn-custom">Connexion Adhérent</a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center p-4 m-2">
                    <h3 class="card-title">Accéder en tant que Bibliothécaire</h3>
                    <p class="card-text">Gérez les prêts, réservations et le catalogue.</p>
                    <a href="/login?role=BIBLIOTHECAIRE" class="btn btn-custom">Connexion Bibliothécaire</a>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

│   │                   login.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bibliothèque - Connexion</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/public.css" rel="stylesheet">
</head>
<body>
    <div class="login-container">
        <h2 class="text-center mb-4" style="color: #8B4513;">Connexion <%= request.getParameter("role") %></h2>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
        <form action="/login" method="post">
            <input type="hidden" name="role" value="<%= request.getParameter("role") %>">
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="mb-3">
                <label for="motDePasse" class="form-label">Mot de passe</label>
                <input type="password" class="form-control" id="motDePasse" name="motDePasse" required>
            </div>
            <button type="submit" class="btn btn-custom w-100">Se connecter</button>
        </form>
        <p class="text-center mt-3">Pas de compte ? <a href="/signin?role=<%= request.getParameter("role") %>">S'inscrire</a></p>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

│   │                   pretForm.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Formulaire de Prêt</h2>
        <form action="/admin/pret" method="post">
            <div class="mb-3">
                <label for="idAdherent" class="form-label">ID Adhérent</label>
                <input type="number" class="form-control" id="idAdherent" name="adherentId" required>
            </div>
            <div class="mb-3">
                <label for="idExemplaire" class="form-label">ID Exemplaire</label>
                <input type="number" class="form-control" id="idExemplaire" name="exemplaireId" required>
            </div>
            <div class="mb-3">
                <label for="typePret" class="form-label">Type de prêt</label>
                <select class="form-control" id="typePret" name="typePret" required>
                    <option value="SUR_PLACE">Sur place</option>
                    <option value="DOMICILE">Domicile</option>
                </select>
            </div>
            <button type="submit" class="btn btn-custom w-100">Valider le prêt</button>
            <c:if test="${not empty message}">
                <p class="success">${message}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>
        </form>
        <a href="/admin/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>

│   │                   retourForm.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Retourner un Prêt</h2>
        <form action="/admin/retour" method="post">
            <div class="mb-3">
                <label for="idPret" class="form-label">ID du Prêt</label>
                <input type="number" class="form-control" id="idPret" name="idPret" required>
            </div>
            <button type="submit" class="btn btn-custom w-100">Retourner le prêt</button>
            <c:if test="${not empty message}">
                <p class="success">${message}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>
        </form>
        <a href="/admin/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>

│   │                   signin.jsp :
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bibliothèque - Inscription</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/public.css" rel="stylesheet">
</head>
<body>
    <div class="signin-container">
        <h2 class="text-center mb-4" style="color: #8B4513;">Inscription <%= request.getParameter("role") %></h2>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
        <form action="/signin" method="post">
            <input type="hidden" name="role" value="<%= request.getParameter("role") %>">
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="mb-3">
                <label for="motDePasse" class="form-label">Mot de passe</label>
                <input type="password" class="form-control" id="motDePasse" name="motDePasse" required>
            </div>
            <% if ("ADHERENT".equals(request.getParameter("role"))) { %>
                <div class="mb-3">
                    <label for="nom" class="form-label">Nom</label>
                    <input type="text" class="form-control" id="nom" name="nom" required>
                </div>
                <div class="mb-3">
                    <label for="prenom" class="form-label">Prénom</label>
                    <input type="text" class="form-control" id="prenom" name="prenom" required>
                </div>
                <div class="mb-3">
                    <label for="dateNaissance" class="form-label">Date de naissance</label>
                    <input type="date" class="form-control" id="dateNaissance" name="dateNaissance" required>
                </div>
                <div class="mb-3">
                    <label for="idProfil" class="form-label">Type de profil</label>
                    <select class="form-control" id="idProfil" name="idProfil" required>
                        <option value="1">ETUDIANT</option>
                        <option value="2">PROFESSIONNEL</option>
                        <option value="3">PROFESSEUR</option>
                    </select>
                </div>
            <% } %>
            <button type="submit" class="btn btn-custom w-100">S'inscrire</button>
        </form>
        <p class="text-center mt-3">Déjà un compte ? <a href="/login?role=<%= request.getParameter("role") %>">Se connecter</a></p>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
</html>
│   │
│   └───test
│       └───java
│           └───com
│               └───biblio
│                   └───service
│                           PretServiceTest.java :
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

     @InjectMocks
    private RetourService retourService;

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

        retourService.retournerExemplaire(1);

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
                () -> retourService.retournerExemplaire(1));
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
                () -> retourService.retournerExemplaire(1));
        assertEquals("Le prêt a déjà été retourné.", exception.getMessage());
    }
}
│
└───target
    │   bibli-0.0.1-SNAPSHOT.jar
    │   bibli-0.0.1-SNAPSHOT.jar.original
    │
    ├───classes
    │   │   application.properties
    │   │
    │   ├───com
    │   │   └───biblio
    │   │       │   Application.class
    │   │       │
    │   │       ├───controller
    │   │       │       AuthController.class
    │   │       │       PretController.class
    │   │       │       RetourController.class
    │   │       │
    │   │       ├───exception
    │   │       │       PretException.class
    │   │       │
    │   │       ├───model
    │   │       │       Abonnement$StatutAbonnement.class
    │   │       │       Abonnement.class
    │   │       │       Adherent$StatutAdherent.class
    │   │       │       Adherent.class
    │   │       │       Exemplaire$EtatExemplaire.class
    │   │       │       Exemplaire$StatutExemplaire.class
    │   │       │       Exemplaire.class
    │   │       │       JourFerie$RegleRendu.class
    │   │       │       JourFerie.class
    │   │       │       jour_ferie$RegleRendu.class
    │   │       │       jour_ferie.class
    │   │       │       Livre.class
    │   │       │       Pret$TypePret.class
    │   │       │       Pret.class
    │   │       │       Profil$TypeProfil.class
    │   │       │       Profil.class
    │   │       │       User$Role.class
    │   │       │       User.class
    │   │       │
    │   │       ├───repository
    │   │       │       AbonnementRepository.class
    │   │       │       AdherentRepository.class
    │   │       │       ExemplaireRepository.class
    │   │       │       JourFerieRepository.class
    │   │       │       jour_ferieRepository.class
    │   │       │       PretRepository.class
    │   │       │       UserRepository.class
    │   │       │
    │   │       └───service
    │   │               AbonnementService.class
    │   │               PretService.class
    │   │               RetourService.class
    │   │
    │   └───templates
    │           index.html
    │           pret.html
    │
    ├───generated-sources
    │   └───annotations
    ├───generated-test-sources
    │   └───test-annotations
    ├───maven-archiver
    │       pom.properties
    │
    ├───maven-status
    │   └───maven-compiler-plugin
    │       ├───compile
    │       │   └───default-compile
    │       │           createdFiles.lst
    │       │           inputFiles.lst
    │       │
    │       └───testCompile
    │           └───default-testCompile
    │                   createdFiles.lst
    │                   inputFiles.lst
    │
    ├───surefire-reports
    │       com.biblio.service.PretServiceTest.txt
    │       TEST-com.biblio.service.PretServiceTest.xml
    │
    └───test-classes
        └───com
            └───biblio
                └───service
                        PretServiceTest.class


base :
drop database if exists gestion_bibliotheque;
CREATE DATABASE if not exists gestion_bibliotheque;
USE gestion_bibliotheque;

CREATE TABLE Profil (
    id_profil INT PRIMARY KEY AUTO_INCREMENT,
    type_profil ENUM('ETUDIANT', 'PROFESSEUR', 'PROFESSIONNEL') NOT NULL,
    duree_pret INT NOT NULL,  
    quota_pret INT NOT NULL,       
    quota_prolongement INT NOT NULL,        
    quota_reservation INT NOT NULL,          
    duree_penalite INT NOT NULL              
);



CREATE TABLE Adherent (
    id_adherent INT PRIMARY KEY AUTO_INCREMENT,
    id_profil INT NOT NULL,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telephone VARCHAR(20),
    statut ENUM('ACTIF', 'INACTIF', 'SANCTIONNE') DEFAULT 'ACTIF',
    date_naissance DATE NOT NULL, 
    quotat_restant int default null, -- Pour vérifier les restrictions d'âge
    FOREIGN KEY (id_profil) REFERENCES Profil(id_profil) ON DELETE RESTRICT
);

CREATE TABLE Abonnement (
    id_abonnement INT PRIMARY KEY AUTO_INCREMENT,
    id_adherent INT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    montant DECIMAL(10,2) NOT NULL,  -- Ajout du montant
    statut ENUM('ACTIVE', 'EXPIREE') DEFAULT 'ACTIVE',
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE
);

CREATE TABLE Livre (
    id_livre INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(255) NOT NULL,
    auteur VARCHAR(255),
    editeur VARCHAR(255),
    annee_publication YEAR,
    genre VARCHAR(100),
    isbn VARCHAR(20) UNIQUE,
    restriction_age INT DEFAULT 0,-- NULL si accessible à tous
    professeur_seulement BOOLEAN DEFAULT FALSE
);

CREATE TABLE Exemplaire (
    id_exemplaire INT PRIMARY KEY AUTO_INCREMENT,
    id_livre INT NOT NULL,
    etat ENUM('BON', 'ABIME', 'PERDU') DEFAULT 'BON',
    statut ENUM('DISPONIBLE', 'EN_PRET', 'RESERVE', 'LECTURE_SUR_PLACE') DEFAULT 'DISPONIBLE',
    FOREIGN KEY (id_livre) REFERENCES Livre(id_livre) ON DELETE CASCADE
);

CREATE TABLE Pret (
    id_pret INT PRIMARY KEY AUTO_INCREMENT,
    id_exemplaire INT NOT NULL,
    id_adherent INT NOT NULL,
    type_pret ENUM('DOMICILE', 'SUR PLACE') NOT NULL,
    date_pret DATETIME NOT NULL,
    date_retour_prevue DATETIME NOT NULL,
    date_retour_effective DATETIME,
    prolongation_count INT DEFAULT 0,
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire) ON DELETE CASCADE,
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE
);


CREATE TABLE Reservation (
    id_reservation INT PRIMARY KEY AUTO_INCREMENT,
    id_exemplaire INT NOT NULL,
    id_adherent INT NOT NULL,
    date_reservation DATETIME NOT NULL,
    date_retrait_prevue DATE NOT NULL,
    date_expiration DATETIME NOT NULL,
    statut ENUM('EN_ATTENTE', 'VALIDEE', 'ANNULEE', 'EXPIREE') DEFAULT 'EN_ATTENTE',
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire),
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent)
);


CREATE TABLE Prolongement (
    id_prolongement INT PRIMARY KEY AUTO_INCREMENT,
    id_pret INT NOT NULL,
    date_demande_prolongement DATETIME NOT NULL,
    nouvelle_date_retour DATETIME NOT NULL,
    statut ENUM('EN ATTENTE', 'VALIDE', 'REFUSE') DEFAULT 'EN ATTENTE',
    FOREIGN KEY (id_pret) REFERENCES Pret(id_pret)
);

CREATE TABLE Penalite (
    id_penalite INT PRIMARY KEY AUTO_INCREMENT,
    id_adherent INT NOT NULL,
    id_pret INT, 
    date_debut_penalite DATE NOT NULL,
    date_fin_penalite DATE NOT NULL,
    raison VARCHAR(255),
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE,
    FOREIGN KEY (id_pret) REFERENCES Pret(id_pret) ON DELETE SET NULL
);

CREATE TABLE jour_ferie (
    id_jourferie INT PRIMARY KEY AUTO_INCREMENT,
    date_ferie DATE UNIQUE NOT NULL,
    description VARCHAR(255),
    regle_rendu ENUM('avant', 'apres') DEFAULT 'avant'
);


INSERT INTO jour_ferie (date_ferie, description, regle_rendu) VALUES 
('2025-01-01', 'Jour de l\'An', 'avant'),
('2025-03-08', 'Journée internationale des femmes', 'avant'),
('2025-03-29', 'Commémoration des martyrs', 'avant'),
('2025-05-01', 'Fête du Travail', 'avant'),
('2025-06-26', 'Fête de l\'Indépendance', 'avant'),
('2025-08-15', 'Assomption', 'avant'),
('2025-11-01', 'Toussaint', 'avant'),
('2025-12-25', 'Noël', 'avant'),
('2025-04-18', 'Vendredi Saint', 'avant'),
('2025-04-20', 'Pâques', 'avant'),
('2025-05-29', 'Ascension', 'avant'),
('2025-06-08', 'Pentecôte', 'avant');

INSERT INTO Livre (titre, auteur, editeur, annee_publication, genre, isbn, restriction_age, professeur_seulement)
VALUES ('Livre Test', 'Auteur Test', 'Editeur Test', 2020, 'Fiction', '1234567890123', 0, FALSE);

INSERT INTO Exemplaire (id_livre, etat, statut)
VALUES (1, 'BON', 'DISPONIBLE');

INSERT INTO Adherent (id_profil, nom, prenom, email, telephone, statut, date_naissance, quotat_restant)
VALUES (1, 'Dupont', 'Jean', 'jean.dupont@example.com', '1234567890', 'ACTIF', '2000-01-01', 3);

INSERT INTO Abonnement (id_adherent, date_debut, date_fin, montant, statut)
VALUES (1, '2025-06-01', '2026-06-01', 50.00, 'ACTIVE');

-- Insert reference data for profiles
INSERT INTO Profil (type_profil, duree_pret, quota_pret, quota_prolongement, quota_reservation, duree_penalite) VALUES
('Etudiant', 7, 3, 1, 2, 10),
('Professionnel', 14, 5, 2, 3, 15),
('Professeur', 30, 3, 3, 5, 7);

CREATE TABLE User (
    id_user INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('ADHERENT', 'BIBLIOTHECAIRE') NOT NULL,
    id_adherent INT, -- NULL pour les bibliothécaires
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent) ON DELETE CASCADE
);

INSERT INTO User (email, mot_de_passe, role, id_adherent)
VALUES ('jean.dupont@example.com', 'ad1', 'ADHERENT', 1);
INSERT INTO User (email, mot_de_passe, role, id_adherent)
VALUES ('bibliothecaire@example.com', 'bibli1', 'BIBLIOTHECAIRE', NULL);

ALTER TABLE Adherent ADD quota_restant INT DEFAULT NULL;
UPDATE Adherent a
SET a.quota_restant = (SELECT p.quota_pret FROM Profil p WHERE p.id_profil = a.id_profil);
