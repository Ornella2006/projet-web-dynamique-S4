Penalite => non rendu de livre
globale pour tous ou par type de profil d'adherent ? => pour tous le monde mais chacun a son nombre de jour par profil, on aprametre : par exemple ce profil 10j ou 20j ou ...
Par contre, y'a des cas : par exemple on est 1er juillet, et il a 2 livres, pret en cours, l'un doit etre rendu 2juillet et l'autre 10juillet et il a pas rendu celui de 2juillet
donc il peut pas prendre de livre que le 12juillet 
et arriver la date de rendu du 2eme livre 10juillet et il l'a pas encore rendu donc + 10j de penalité encore, c'est pas a partir de 10Juillet qu'on fait + 10j de penalité mais sur sa date de sanction 12Juillet donc ca devient 22juillet qu'il peut reprendre

cotat {
    par profil
    ce profil peut prendre 5 ou 3 nombres de livre
}

nombre de prolongements parallere à parametrer {
    ne peut pas faire prolongements de pret 3 en meme temps
    y'a pas de pret prolonger 3 en cours
    on doit savoir quand ce pret en cours si c'est prolonger ou pas car on limite le pret
    si c'est pret normale peut prendre 5
    et on lui dit qu'il ne peut faire de prolongement que 2 de ces prets
    donc 3 prets normale et 2 prets prolongées par exemple 
}

cotat non renouveler => parametrer
pret => cotat dans la base en cours 

interface ou script dans bd => update de cotat

Pa rapport a la penalité c'est apres qu'on l'ait rendu qu'on compte les jours de penalisation ou ?
=> y'a un livre qui devrait etre rendu un 1er Juillet or il l'a rendu que le 3Juillet donc c'est à partir du 3Juillet qu'on compte et qu'on ajoute les jours de penalisation dans la base
=> s'il a pas pu rendre celui apres et quand il le rend enfin, c'est encore + 10j donc à partir de 13Juillet qu'il peut reprendre
et si par exemple il a encore un autre livre qu'il devrait rendre le 5Juillet or il l'a rendu le 8Juillet alors ses jours de penalisation sera compter a partir de 12Juillet veille de penalisation de celui d'avant

donc il sera penalisé
si par exemple il devait rendre un livre le 7 Juillet mais que le 8 Juillet il va prendre un autre livre => alors il peut car y'a encore un livre qu'il n'a pas encore rendu par contre => la sanction ne commencer(effective) a qu'a partir
du jour qu'il aurait rendu le livre

abonnement => date seulement, ici jusqu'ici il est abonner 
inscription => abonnement

bibliothecaire dit juste ce adherent est abonner ici jsqu'à tel date
adherent a login et mdp peut entre dedans mais ne peut rien faire

renouvellement d'abonnement => on a seulement besoin de periode(date)

cotat => 3livres, il a pris 1 sur 3, et ce 1 doit etre rendu 10Juillet et il l'a pas encore rendu et le 11Juillet il veut prendre un livre => ne peut pas car il a pas encore rendu celui qu'il devait rendre a sa date prevu de retour 

mais ne peut rien prendre s'il est pas abonner
cotat lier au profil

----*-----
reservation peut etre accepter et peut ne pas etre accepter par le bibliothecaire, le systeme ne met pas des regles
et meme s'il accepte ca ne devient pas directement un pret mais l'adherent durant la date jour j de la reservation 
devrait preter le livre => et c'est là que tous les regles de gestion entrent => annuler reservation dans ce cas

----*-----
reservation => quotat
prolongement de pret => quotat
quotat et tarif pareil 

il peut toujours voir l'etat ou la fiche de l'adherent mais on ne voit pas les regles dans l'accepation ou recu de reservation mais c'est juste le bibliothecaire qui dit s'il accepte ou s'il le revise

jour ferier => weekend et jour ferier ensemble {
    check dans une table => OUI ou non
    change avec ca date retour
    c'est a nous de choisir ou le faire, au moment du pret ou ...

}

reservation et pret en retard => ne sont pas liés
Retard {
    t'es en retard et tu veux prendre un livre (exemplaire) => tu peux pas
    s'il y'a une reservation deja accepté et que tu veux rendre en pret => tu ne peux pas => pareil que pret normale car prend deja les regles de gestion du pret a la minute ou tu veux rendre en pret
}

le livre reste juste reserver => meme si c'est un adherent sanctionner qui l'a reserver, par exemple la reservation a deja ete accepter mais le bibliothecaire peut faire des recherches et il peut refuser 
un tel ou telle reservation

s'il y'a une reservation et que tu n'a pas rendu un livre => n'est pas transformé en pret, et si y'a une reservation deja accepter et que tu veuille en faire un pret => ne peut pas si tu n'a pas encore rendu de livre 
livre => reserver => meme si l'adherent est sanctionner

la bibliothecaire peut faire des recherches qu'il annule les reservations