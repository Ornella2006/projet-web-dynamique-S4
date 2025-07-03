Je suis une etudiante en informatique en 2eme année en 2eme semestre (S4) et pendant notre examen de web dynamique, notre prof nous demande de faire un projet en utilisant les technologies spring MVC et on a le choix entre utiliser egalement Spring Boot avec ou non et comme base on a eu libre choix et je vais utiliser mysql
Le theme du projet est la Gestion de Bibliotheques
Il avait dit qu’il allait parer des modules ou des grandes lignes des fonctinnalités mais il ne l’a pas fait finalement
Par contre il nous a fourni ces explicaitions ci dessous :
Livre => exemple de regles de gestio, => => y'a des livres qui ne peuvent etre emprunter a domicile que par les professeurs par exemple
.Exemplaire de livre
.Pret: Lecture sur place, maison
. Adherent: Etudiant, Professionel, Professeur => regles de gestion differents, regles de gestion peut se porter sur duree de pret et nombre de livre emprunter
. Penalite
. Cosisation ou Inscription => ici je ne sais pas si j’ai pas bien entendu, je sais pas si c’etait Cotisation “et” Inscription ou Cotisation ou Inscription
. reservation/profil par type pret si c'est encore disponible
.prolongement
.gestion jour ferie

Pour les restrictions des livres il en a parlé {
    Ça concerne l’age 
    Y’a des livres qui ne peut etre empreinter par des adherents de moins de 18ans
    mais apart on peut tous empreinter
}	

Si tu rends pas un livre => penalisation => peut pas prendre un livre pendant un certain temps => et durée de ce certain temps parametrable => depend du profil de l’adherent

Carte membre valide que pour une durée limitée {
    paiement => valide de ce jour jusque ce jour
    sans reabonnement tu peux pas prendre de livre
}

quota par profil
livre/exemplaire => on peut mettre regle par rapport au profil ou age

Puis l’apres midi, il a fourni ces explications egalement :
1/ reservation {
    y'a quelqu'un qui peut reserver un pret et qui dit moi je veux emprunter ce livre a ce date,
    par profil nombre de livres qu'il peut reserver et par rapport au type de pret egalement
    basé aussi sur la disponibilité du livre
    ex : livre reserver 7 juillet 
    .adherent quand il rentre dans le systeme savent quand tous les exemplaire sur ce livre revienne
    et il voit par exemple 6juillet tous les exemplaire reviennent ou qu'un seule exemplaire est disponible(revienne)
    bah il peut reserver pour 7juillet => demande de reservation qu'il fait
    et ce livre n'est pas encore reserver, besoin de Bibliothecaire pour valider(accepter) la reservation
    et quand c'est accepter par le Bibliothecaire => le livre devient indisponible quand y'a un autre adherent qui fait la recherche de cet
    exemplaire et son etat devient => "reserver"
    etat => disponible, en pret, reserver, en lecture sur place => 4etats des exemplaires
    ce n'est que quand c'est disponible qu'on peut en faire un pret

    et vint la personne ou l'adherent le 7juillet pour dire qu'il en a deja fait la reservation de l'exemplaire en question
    et le Bibliothecaire voit directement qu'il l'a reserver et le livre ou l'exemplaire devient non disponible et l'exemplaire 
    devient pret en "domicile" par contre si la personne ou l'adherent ne vient jusqu à la tombée du jour, le lendemain l'exemplaire redevient dispo

    RESERVATION / par profil
}

 2/ PROLONGEMENT PAR PROFIL egalement {
    c'est par profil qu'on peut dire qu'il peut le faire et s'il peut le faire alors combien de fois il peut faire le prolongement et combien d'exemplaires
    il peut faire en parallele de prolongement de pret
    .Par exemple si le pret doit etre terminer 28 juin
    on peut aussi dire la date de demande de prolongement, exemple 2jours a l'avance et le "2" est parametrer et s'il dit 2j ou 48h a l'avance(fin 
    de pret), il demande de prolonger le pret car il va pas le rendre le 28juin
    et c'est le Bibliothecaire qui valide ce prolongement mais y'a aussi des regles de gestion qui sont placées qu'on ne peut pas demander des prolongements si 
    tu as atteint tes quotas et si tu n'a pas la permission => le bouton prolongement de pret n'est juste pas disponible(desactiver) dans ces cas là
    .Les adherents rentrent et ils voient directe la liste de leurs prets en cours et seuls ceux qui sont autorisées et possible de prolongement => y'a deja le bouton prolonger le pret a coté sinon c'est pas possible
    .tu demandes un prolongement => valider par le Bibliothecaire => apres validation du Bibliothecaire => si c'etait 28juin que le livre devait etre rendu mais que ta durée est de 7jours 
    alors le livre peut finalement etre rendu et etre disponible le 5juillet, date de rendu prevu apres prolongement de pret

 }

 3/ Gestion de jour ferié {
    par exemple tu as prevu de rendre un livre un 26juin or la Bibliotheque est fermé donc devrait stocker tous les jours feries dans le systemes donc si le livre n'est pas rendu le 26juin alors tu ne
    seras pas penalisé car meme la Bibliotheque etait fermé, regle qui doit etre contenu => parametres => avant ou apres qu'il doit etre rendu et le Bibliothecaire est libre de mettre ces 
    conditions, s'il le fait avant et que tu prends un livre qui devrait etre rendu le 26juin alors il te dit de le rendre 25juin apres avoir fais ton pret, il fait un recap et te dit que tu dois le 
    rendre 25Juin car on est feriées le 26juin mais si on fait moins alors date anterieur c'est-a-dire jours ouvrables plus proche antérieurement, par exemple si c'est lundi de pentecote que tu 
    aurais du rendre le livre et que si la regle choisit est celui d'antérieur alors vendredi avant lundi de pentecote que tu dois rendre le livre si la Bibliotheque ne travaille pas samedi mais
    samedi s'ils travaillent quand meme 


 }

QUESTION DES ELEVES :
si par exemple y'a quelqu'un qui veut prolonger la date de rendu de pret de son livre or un autre adherent ayant vu la date de disponibilité a deja reservé le livre en question et a deja ete valider
par le Bibliothecaire alors l'autre adherent ne peut plus prolonger le livre car c'est toujours celui valider par le Bibliothecaire en premier qui est prise en compte

prolongement => parametrer absolument
tous ce qu'on fera dans ce projet sera parametrables => car c'est cela un projet réel,aucun parametres dans les codes sources au pire fichier de configuration ou base et a un interface de configuration

regles de jour ferié => par Bibliotheque ou par pret ? la reponse est par Bibliotheque et si l'Etat dit par exemple on est feriés a ce jour ou tel jour alors on introduiera dans le systeme ce jour en question
et tous les prets contractés avant qu'on ait inserer ce nouveau jour ferié => change tous directement car par exemple il devait etre rendu en ce nouvel jour ferié meme or on vient d'introduire que ce jour etait
ferié alors il devrait etre rendu avant ou apres dependra du parametrages qu'on aurait fait pour le jour ferié

apres il a aussi fourni ces explications mais c'est ça concerne plus une methologie de travail, ne concerne pas 100% notre projet mais je vous le fournis quand meme : 
liste de fonctionnalités à faire
comment expliquer ou donner des informations sur les fonctionnalités
Exemple de cas : 1 fonctionnalités :
on lui donne un nom
doit etre infinitif => verbe d'action
exemple : preter un livre/exemplaire

fonctionnalités => un methode dans une couche service
on devrait avoir une classe PreteService et dedans y'a une methode PreterLivre(ref exemplaire, ref adherent)

description de cas d'utilisation qu'on fait en premier et c'est ca que le developper regarde pour etre transformer en code
et l'ensemble de description + fonctionnalités => en grande partie appeler cahier de charge
on implemente preter un exemplaire(reservation d'exemplaire) => on devrait avoir des informations qu'on ecrira=> et c'est ca qui est transformer en code

UML => fonctionnalité => use case ou cas d'utilisation
uml = methodologie pour faire la conception de systeme d'informations, donne bcp de diagramme, issu des besoins, si on veut creer , 1ere chose a faire => requiert de besoin
recueil de besoin par le biais d'entretien(discussion environnement client, analyse de l'existant), etc apres => cahier de charge => besoin fonctionnel => liste et description fonctionnalités, besoin fonctionnels
demande du client en terme de fonctionnalités futur du systeme
listé fonctionnalités => on peut utiliser avec le cahier de charge => norme UML(à quelque chose pres) pour decrire chaque fonctionnalités, peut ne pas l'utilser mais utiliser d'autres canevas
exemple textuelle ou excel

ensemble DE CELA => grande partie => cahier de charge
cahier de charge => besoin fonctionnels et besoins non fonctionnels(doivent etre mis dans le cahier de charge) => conception 
.besoins non fonctionnels {
    entretien => requiert de besoin, pas forcement un entretien peut etre le client fourni un document, dans le requiert des besoins,
    on peut voir qu'y a des exigences, y'a d'autres besoins mais qui ne sont pas fonctionnels (durée de chargement de page, chart graphique,
    par exemple des exigences comme faut utiliser dotnet car on a une license microsoft => devrait etre mise dans le cahier de charge)
} 

conception (architecture, technologies) { => en general conception relationnelle
    donnees
    traitement
    => UML peut entrer dans l'expression et la presentation de la conception
    conception relationnelle, on peut faire diagramme MPD (Model Physic de Donnee)
    concepteur => on peut utliser schema proposé par UML pour remplir le document de la
    conception
    comment faire la conception de traitement de ceci => le notre, on ne demande pas encore ca maintenant
    mais on peut tres bien l'exprimer avec les diagrammes d'UML (UML a 9 diagrammes)
    conception => on a besoin d'exprimer la conception par rapport aux besoins ou exigences ecrit dans le cahier de charges
    peut ne pas etre shematiser mais seulement textuelle 
    exemple : table : colonne
    reponse de la conception exprimer par nous humain, peut etre textuelle, schematiser
    schema => plus rapide a lire et a comprendre, proposé par UML aux différentes etapes que ca soit au niveau cahier de charge,
    traitement, conception, deploiement qu'on peut utliser pour faciliter la presentation de ce qu'on veut afficher que ca soit au niveau des
    cahiers de charge ou conception relationnelle ou traitement ou deploiement => c'est le but de UML
}

cas d'utilisation => cahier de charges

diagramme de cas d'utilisation => liste de fonctionnalités, au lieu de lister on fait cas d'utilisation par Acteur
Par exemple Acteur Bibliothecaires {
    il peut preter un livre/exemplaire
    rendre un livre
    ajouter un adherent
}
important => qu'on ait finit de decrire les fonctionnalité

description des fonctionnalités {
    qui profil peut ...
    creer type de pret (
        peut etre sur place ou a domicile => on doit avoir une table fonctionnalité 4 CRUD
    )
    a plusieurs regles de gestion doivent etre decrits correctement
}

puis ceci aussi :
Nom(Titre) : Preter un (exemplaire) livre
Objectif : textuelle ...
Acteur(Utilisateur) : (profil) bibliothecaires
Entrée(INPUT) : ref ex, ref adherent(cota peut etre obtenu via ceci) => qu'est ce dont on a besoin pour traiter la fonctionnalité, iformations ? données ?
Scenario nominal :description fonctionnel d'un cas d'utilisation, description interface,  evenement lier a la fonctionnalité <= c'est ce que regarde les frontend developper, car dans backend developper, il n'a pas besoin de savoir comment on va utliser cette fonction car il a seulement besoin de le créer mais si il va faire full stack c'est là qu'il en a egalement besoin
                  (Acteur) se connecte 
                  Va 'a menu' Preter un livre
                  Remplir champ "adherent", "exemplaire"
                  Cliquer sur le bouton "Enregistrer"
                  exemplaire preté par l'adhérent
                  

CAHIER DES CHARGES : les fonctionnalités devraient etre dans les couches service
Regle de gestion par rapport à pret d'un livre par un adherent (les checks a faire dans une fonction) (fonctionnalité = USE CASE = cas d'utilisation) = description fonctionnel des cas d'utilisation : => se rapporche de la description de la methodologie de UML, quoi que ne suit pas à 100% la methodologie d'UML, mais on peut quand meme expliquer un fonctionnalité
    -adh doit etre actif
    -adh existe (son numero)
    -exemplaire disponible
    -quota ?
    -sanction adherent ?
    -adherent abonné ? 
    -exemplaire existe
    -adherent peut prendre l'exemplaire ? => regle au niveau livre
    -adherent age ? regle associé @exemplaire ? si y'a une regle approprié pour l'age de l'adherent ?
    -etc

Scenario alternative a la regle de gestion : => plutot interface
si la(es) regle(s) de gestion n'est pas satisfait : si y'en a une qui n'est pas satisfait
affichage message d'erreur => rediriger page d'acceill
avec cause d'erreur 
si c'est sanction, on affiche => jusqu'a tel date 
expiration abonnement => date si l'adherent n'est plus abonnée
restriction a propos de l'age => et toi tu n'en fais pas encore partie
.toujours dire les causes des erreurs

RESULTAT : cette partie qu'on ecrit les test unitaires => details de chacun des cas
Si tous les regles de gestion sont satisfait {
    (
        adherent inactif => erreur
        adherent augmente +1 => son pret
        adh -1 (nmbre de livre qu'il peut prendre)(quota)
        exemplaire => indisponible =>jusqu'au date associé a date duree de pret de l'adherent
        
    )
Sinon : on throws exception
    (
        Si
            adh prend un exemplaire          >18, on prend comme ceci tous les cas
            => message d'erreur=> quota ex: ne diminue pas, livre reste la meme etat, 

            adh sanctionner => message d'erreur
            pret non fini => etat avant, si on prend un exemplaire disponible il sera toujours disponible 

    )
}

devrait etre fais dans une couche Service

implementation de cette methode => on connait deja ce qui va se transformer en argument (regle de gestion), interface (scenario nominal, alterantif et resultat)

conception => le plus difficile

test unitaire => interface (y'a un outil) => remplissage de formulaire => fait un submit et test automatiquement
test unitaire de methode => methode de service ou couche service
doit avoir une classe de test : PretServiceTest; methode => PreterLivre => PreterLivreTest
dans PreterLivreTest {
    on fait select pour appeler serviceDAO dans la coucheDAO, faire une select : donne moi l'adherent => qui est à la fois actif, a encore du cotat et peut
    prendre ce livre
    et on prend le livre et on appelle PreterService(PreterLivre) et on lui donne l'argument et apres on verifie, comment ? tous ce qui est ecrit => 
    tester puis on va dans la base => on appelle vers la base, cet adherent combien de livres restant, il peut prendre => devrait diminuer d'1
    .avant preterLivre on devrait savoir le numero d'exemplaire disponible, on lance le preterLivre et apres on verifie qu'il n'est plus dispo, et sa date =>
    date du jour(date de retour du livre) + nmbre de durée de pret associé au profil de l'adherent => implementation serieux de fonctionnalité
}

Test avant implementation
au lieu de faire if, dans la base on doit toujours prendre, appel de PreterLivre on doit toujours faire mais le faisage de if 
on peut utiliser des fonctions condensées , des assertions qui font generalement des asserts

librairie ou framework=> test unitaire JUNIT si on utilise JAVA, Test ng, peut etre coupler dans le projet et on declare class de test 
par le biais des annotations, on lance pas un par un les méthodes car ils sont plusieurs et c'est là le travail des framework de tester les term
un clic et il balaye les classes declarées test et il appelle un par un les classes de test et il fait un rapport si c'est 100% successfull ou non (failed)
et il dit ce qui ne vas pas => assurer que les fonctionnalités marchent vraiment et assurent la robustesse de l'application qu'on fait => ecriture de test unitaires

Après il a egalement expliquer une architecture de methodologie de travail genre un workflow ou flux de travail :


