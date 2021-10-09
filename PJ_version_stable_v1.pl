%%% INFO-501, TP3
%%% Pierre Hyvernat
%%%Delifer Paul Guesdon
%%% Lancez la "requête"
%%% jouer.
%%% pour commencer une partie !
%

% il faut déclarer les prédicats "dynamiques" qui vont être modifiés par le programme.
:- dynamic position/2, position_courante/1.
:- dynamic doloreane/2, temps_courant/1.
:- dynamic position/3, position_courante/1.
% on remet à jours les positions des objets et du joueur
:- retractall(position(_, _)), retractall(position_courante(_)).
:- retractall(doloreane(_, _)), retractall(temps_courant(_)).
:- retractall(position_objets(_, _, _)), retractall(position_courante(_)).

% on déclare des opérateurs, pour autoriser `prendre torche` au lieu de `prendre(torche)`
:- op(1000, fx, prendre).
:- op(1000, fx, lacher).
:- op(1000, fx, aller).

est_dans_liste(tri_par_bulle):-true,!.
est_dans_liste(_):-write("tu ne peux pas mettre ça!"), false, !.
%Temporalité du joueur. Ce predicat sert a definir dans quelle timeline le joueur se trouve
temps_courant(present).
voyage(X,Temps):-
        temps_courant(Fromage),
        est_dans_liste(X),
        utiliser(X),
        decrire(X),
        retract(temps_courant(Fromage)),
        assert(temps_courant(Temps)),
        regarder, !.
voyage(_,_):-write("la voiture n'est pas alimenté"), false, !.

% position du joueur. Ce prédicat sera modifié au fur et à mesure de la partie (avec `retract` et `assert`)
position_courante(usmb_cours).

%utiliser objet
utiliser(X):-
        position(X,en_main),
        retract(position(X, en_main)),
        assert(position(X, vide)),
        !.
utiliser(X):-
        write("je ne vois pas de "),
        write(X), 
        write("dans votre main"),
        !.


% passages entre les différent endroits du jeu

%Present%
        %cours lama
        passage(usmb_cours, ouest, lama).
        passage(lama, est, usmb_cours).
        %cours canton
        passage(usmb_cours, est, quattreCanton).
        passage(quattreCanton, ouest,usmb_cours).
        %canton polytech
        passage(quattreCanton, nord, polytech).
        passage(polytech, sud, quattreCanton).
        %cours 8b
        passage(usmb_cours, sud, huitB).
        passage(huitB, nord,usmb_cours).

% position des objets
%modele osi
position_objets(modele_osi, lama, present).
%Tri par bulle obtenu après avoir parlé du modele osi a M.garet
position_objets(tri_par_bulle, lama, temps_courant(present)).

%copies des eleves%
position_objets(copies_pourraves,huitB, temps_courant(present)).

% ramasser un objet
prendre(X) :-
        position_objets(X, en_main, temps_courant(present)),
        write("Vous lavez déjà !"), nl,
        !.

%%%%%%%%%prendre et surcharges de prendre%%%%%%%%%%%
prendre(X) :-
        position_courante(P),
        position_objets(X, P, temps_courant(present)),
        retract(position_objets(X, P, temps_courant(present))),
        assert(position_objets(X, en_main,temps_courant(present))),
        assert(position(X, en_main)),
        write("OK."), nl,
        !.
prendre(X) :-
        position_courante(P),
        position_objets(X, P, temps_courant(passe)),
        retract(position_objets(X, P, temps_courant(passe))),
        assert(position_objets(X, en_main,temps_courant(passe))),
        write("OK."), nl,
        !.
prendre(X) :-
        position_courante(P),
        position_objets(X, P, temps_courant(futur)),
        retract(position_objets(X, P, temps_courant(futur))),
        assert(position_objets(X, en_main,temps_courant(futur))),
        write("OK."), nl,
        !.



prendre(X) :-
        write("??? Je ne vois pas de "),
        write(X),
        write(" ici."), nl,
        fail.


% laisser un objet
lacher(X) :-
        position(X, en_main),
        position_courante(P),
        retract(position(X, en_main)),
        assert(position(X, P)),
        write("OK."), nl,
        !.

lacher(_) :-
        write("Vous navez pas ça en votre possession !"), nl,
        fail.


% quelques raccourcis
n :- aller(nord).
s :- aller(sud).
e :- aller(est).
o :- aller(ouest).


% déplacements
aller(Direction) :-
        position_courante(Ici),
        passage(Ici, Direction, La),
        retract(position_courante(Ici)),
        assert(position_courante(La)),
        regarder, !.

aller(_) :-
        write("Vous ne pouvez pas aller par là."),
        fail.


%De%
% regarder autour de soi
regarder :-
        position_courante(Place),
        decrire(Place), nl,
        lister_objets(Place), nl.


% afficher la liste des objets à lemplacement donné
lister_objets(Place) :-
        position_objets(X, Place, temps_courant(_)),
        write("Il y a "), write(X), write(" ici."), nl,
        fail.

lister_objets(_).

% add_tail(+List,+Element,-List)
% Add the given element to the end of the list, without using the "append" predicate.

% fin de partie
fin :-
        nl, write("La partie est finie."), nl,
        halt.


% affiche les instructions du jeu
instructions :-
        nl,
        write("Les commandes doivent être données avec la syntaxe Prolog habituelle."), nl,
        write("Les commandes existantes sont :"), nl,
        write("jouer.                   -- pour commencer une partie."), nl,
        write("n.  s.  e.  o.           -- pour aller dans cette direction (nord / sud / est / ouest)."), nl,
        write("aller(direction)         -- pour aller dans cette direction."), nl,
        write("prendre(objet).          -- pour prendre un objet."), nl,
        write("lacher(objet).           -- pour lacher un objet en votre possession."), nl,
        write("regarder.                -- pour regarder autour de vous."), nl,
        write("instructions.            -- pour revoir ce message !."), nl,
        write("fin.                     -- pour terminer la partie et quitter."), nl,
        nl.

%--------------------------------------------------------------------------------------------------------------%

% lancer une nouvelle partie
jouer :-
        instructions,
        write("Catastrophe! Jean-Charles Marty revient du futur pour annoncer la nouvelle!"), nl,
        write("Les licenses 3 ont foirés leurs projets. L université est désormais discreditée et"), nl,
        write("est devenue la risée de la communauté universitaire dans le domaine informatique"), nl,
        write("Plus aucune entreprise ne veut proposer de projets aux futurs étudiants de L3"), nl,
        write("Votre mission, Si vous l acceptez est de parcourir les différentes époques"), nl,
        write("afin de retrouver les algorithmes de tri permettant d écrêmer la license."), nl,nl,
        regarder.
% descriptions des emplacements du passé
decrire(usmb_cours) :- temps_courant(passe),
    write("SMEGMA"), nl,
    write("vous appercevez marty, accompagné de son fidèle compagnon le boussion-ardent, non loin de sa doloréane"), nl,!
    .

decrire(lama) :- temps_courant(passe),position(copies_pourraves,vide),
    write("tri par bulle vide"), nl,
    write(""), nl,!
    .
decrire(lama) :- temps_courant(passe),
    write("SMEGMA"), nl,
    write(""), nl,!
    .

decrire(quattreCanton) :- temps_courant(passe),
    write("SMEGMA"), nl,
    write(""), nl,!
    .
decrire(polytech) :- temps_courant(passe),
    write("SMEGMA"), nl,
    write(""), nl,!
    .

% descriptions des emplacements du present
decrire(usmb_cours) :- temps_courant(present),
    write("vous vous trouvez dans la cours de l usmb"), nl,
    write("vous appercevez marty, accompagné de son fidèle compagnon le boussion-ardent, non loin de sa doloréane"), nl,!.


decrire(lama):- temps_courant(present),
        write("Vous arrivez dans ce prestigieux laboratoire. Vous appercevez M. Hyvernat devant la machine a caffé"), nl,
        write("nn"),nl,!.

decrire(quattreCanton):-temps_courant(present),
        write("quattreCanton"), nl,!.

decrire(huitB):-temps_courant(present),
        write("huitB"), nl,!.

decrire(polytech):-temps_courant(present),
        write("polytech"), nl,!.
%%%%%%%%%%%Description des emplacements du futur
decrire(usmb_cours) :- temps_courant(futur),
    write("vous etes dans la cours de l'usmb, cette cours est mal entretenu et des rat parcours la structure"), nl,
    write("vous appercevez marty, accompagné de son fidèle compagnon le boussion-ardent, non loin de sa doloréane"), nl,
    !.

decrire(lama):- temps_courant(futur),
    write("Vous arrivez dans ce vetistute laboratoire. la machine a cafféest cassé "), nl,
    write("M hyvernat est dans son bureau a corriger des copie de scratch"), nl,
    !.
decrire(quattreCanton):- temps_courant(futur),
    write("vous arriver dans les très vieux batiment de l'univ"), nl,
    write("mais pour une foix ces batiment sont raccord avec le reste de l'univ"), nl,
    write("on y appercois garret toujours en train de cermoner les l1:"), nl,
    write("defaillant au tp, défaillant au semestre défaillant a l'année, on est d'accord?"), nl,
    write("...on est d'accord."),
    write("il vous interpelle et vous dit:"),
    write("zizi"),
    nl,
    !.
decrire(huitB):- temps_courant(futur),
    write("dernier grand batiment de cette université qui n'a pas encore été détruit"), nl,
    write("on y voit jol sur sont projet scret le fameux c+++"), nl,
    !.
decrire(polytech):- temps_courant(futur),
    write("polytech est devenu un champ de ruine depuis les incidents du tp3 de logique"), nl,
    write("wental est en train de dévelloper une applis mobile pour partir d'ici"), nl,
    !.

decrire(modele_osi):-position_courante(lama),temps_courant(present),
        write("un modele perdu dans les ages. Selon Maitre Bauzac"),nl,
        write("ce puissant arcane n'a pas ete implemente mais decrit les loi regissant l'internet"),nl,
        write("Ce modele pourrait interesser M.Garet"),nl.
%%Il faudrait amener l'algo de tri par bulle à hyvernat%%
decrire(tri_par_bulle):-position_courante(lama),temps_courant(present),
        write("Cet Algorithme de tri, bien que de complexité constante n2"),nl,
        write("doit etre utilisé avec jugeotte! Dans le cas contraire"),nl,
        write("la situation risquerait de dégénérer"),nl.
decrire(tri_par_bulle):-position(tri_par_bulle,vide),
        write("tu as mit le tri par bulle dans la dolorean"),nl,
        write("nous pouvons partir!!! en route!"),nl.

%copies d'étudiants%


%copies du temps présent%
decrire(copies_partiels_logique):-
        write("Ces copies sont remplies de symboles incompréhensibles."),nl,
        write("Absurde A(xor(non(non(AouBou(non(BetZxorC))))))"),nl,
        write("Aidez-Moi!").

decrire(copies_pourraves):-
        write("Beeeerk! quesce-que c'est? Des maths'? Au secours..."),nl.

decrire(copies_systeme_dexploitation):-
        write("Ce sont des copies de systeme d'exploitation"),nl,
        write("Ce sont vraiment des torchons..  noyaux systemes.. distributions.. assembleur.."),nl,
        write("Tout ce qu'il faut pour devenir SYSadmin.. Un beau metier"),nl.

%copies du futur%
decrire(copies_dun_ancien_temps):-
        write("Ahh, je me rappelle de cette matiere.."),nl,
        write("Ce sont des copies d'info101'.. La bonne époque"),nl.

decrire(copies):-
        write("null"),nl.