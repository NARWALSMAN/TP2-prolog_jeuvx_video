%%% INFO-501, TP3
%%% Pierre Hyvernat
%%%Delifer Paul Guesdon
%%% Lancez la "requ�te"
%%% jouer.
%%% pour commencer une partie !
%

% il faut d�clarer les pr�dicats "dynamiques" qui vont �tre modifi�s par le programme.
:- dynamic position/2, position_courante/1.
:- dynamic doloreane/2, temps_courant/1.
:- dynamic position/3, position_courante/1.
% on remet � jours les positions des objets et du joueur
:- retractall(position(_, _)), retractall(position_courante(_)).
:- retractall(doloreane(_, _)), retractall(temps_courant(_)).
:- retractall(position_objets(_, _, _)), retractall(position_courante(_)).

% on d�clare des op�rateurs, pour autoriser `prendre torche` au lieu de `prendre(torche)`
:- op(1000, fx, prendre).
:- op(1000, fx, lacher).
:- op(1000, fx, aller).
%Def de liste de copies%
est_dans_liste(copies_dun_ancien_temps):-true,!.
est_dans_liste(copies_pourraves):-true,!.
est_dans_liste(copies_systeme_dexploitation):-true,!.
est_dans_liste(copies_pourraves):-true,!.
est_dans_liste(copies_grammaire_automates):-true,!.
est_dans_liste(copies_d_algorithmique):-true,!.
est_dans_liste(_):-write("tu ne peux pas mettre ca!"), false, !.
%Temporalit� du joueur. Ce predicat sert a definir dans quelle timeline le joueur se trouve
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

% position du joueur. Ce pr�dicat sera modifié au fur et a mesure de la partie (avec `retract` et `assert`)
position_courante(usmb_cours).

%utiliser objet
utiliser(X):-
        position(X,en_main),
        retract(position(X, en_main)),
        assert(position(X, vide)),
        decrire(X),
        !.
utiliser(X):-
        write("je ne vois pas de "),
        write(X), 
        write("dans votre main"),
        !.


% passages entre les diff�rent endroits du jeu

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

% position des objets'
%modele osi
position_objets(modele_osi, lama, present).
%Tri par bulle obtenu apr�s avoir parl� du modele osi a M.garet
position_objets(tri_par_bulle, lama, temps_courant(present)).

%copies des eleves%
position_objets(copies_pourraves,huitB, temps_courant(present)).
position_objets(copies_partiels_logique,quattreCanton, temps_courant(present)).

position_objets(copies_grammaire_automates,huitB, temps_courant(passe)).
position_objets(copies_systeme_dexploitation,huitB, temps_courant(passe)).

position_objets(copies_partiels_logique,lama, temps_courant(futur)).
position_objets(copies_dun_ancien_temps,huitB, temps_courant(futur)).
% ramasser un objet
prendre(X) :-
        position_objets(X, en_main, temps_courant(present)),
        write("Vous lavez d�j� !"), nl,
        !.

%%%%%%%%%prendre et surcharges de prendre%%%%%%%%%%%
prendre(X) :-
        position_courante(P),
        position_objets(X, P, temps_courant(present)),
        retract(position_objets(X, P, temps_courant(present))),
        assert(position_objets(X, en_main,temps_courant(present))),
        assert(position(X, en_main)),
        write("OK."), nl,
        decrire(X),
        !.
prendre(X) :-
        position_courante(P),
        position_objets(X, P, temps_courant(passe)),
        retract(position_objets(X, P, temps_courant(passe))),
        assert(position_objets(X, en_main,temps_courant(passe))),
        write("OK."), nl,
        decrire(X),
        !.
prendre(X) :-
        position_courante(P),
        position_objets(X, P, temps_courant(futur)),
        retract(position_objets(X, P, temps_courant(futur))),
        assert(position_objets(X, en_main,temps_courant(futur))),
        write("OK."), nl,
        decrire(X),
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
        write("Vous navez pas �a en votre possession !"), nl,
        fail.


% quelques raccourcis
n :- aller(nord).
s :- aller(sud).
e :- aller(est).
o :- aller(ouest).


% d�placements
aller(Direction) :-
        position_courante(Ici),
        passage(Ici, Direction, La),
        retract(position_courante(Ici)),
        assert(position_courante(La)),
        regarder, !.

aller(_) :-
        write("Vous ne pouvez pas aller par l�."),
        fail.


%De%
% regarder autour de soi
regarder :-
        position_courante(Place),
        decrire(Place), nl,
        lister_objets(Place), nl.


% afficher la liste des objets � lemplacement donn�
lister_objets(Place) :-
        position_objets(X, Place, temps_courant(_)),
        write("Il y a "), write(X), write(" ici."), nl,
        fail.

lister_objets(_).


% fin de partie
fin :-
        nl, write("La partie est finie."), nl,
        halt.


% affiche les instructions du jeu
instructions :-
        nl,
        write("Les commandes doivent �tre donn�es avec la syntaxe Prolog habituelle."), nl,
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
        write("Les licenses 3 ont foir�s leurs projets. L universit� est d�sormais discredit�e et"), nl,
        write("est devenue la ris�e de la communaut� universitaire dans le domaine informatique"), nl,
        write("Plus aucune entreprise ne veut proposer de projets aux futurs �tudiants de L3"), nl,
        write("Votre mission, Si vous l acceptez est de parcourir les diff�rentes �poques"), nl,
        write("afin de retrouver les algorithmes de tri permettant d �cr�mer la license."), nl,nl,
        regarder.
% descriptions des emplacements du pass�
decrire(usmb_cours) :- temps_courant(passe),
    write("SMEGMA"), nl,
    write("vous appercevez marty, accompagn� de son fid�le compagnon le boussion-ardent, non loin de sa dolor�ane"), nl,!
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
    write("vous appercevez marty, accompagn� de son fid�le compagnon le boussion-ardent, non loin de sa dolor�ane"), nl,!.


decrire(lama):- temps_courant(present),
        write("Vous arrivez dans ce prestigieux laboratoire. Vous appercevez M. Hyvernat devant la machine a caff�"), nl,
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
    write("vous appercevez marty, accompagn� de son fid�le compagnon le boussion-ardent, non loin de sa dolor�ane"), nl,
    !.

decrire(lama):- temps_courant(futur),
    write("Vous arrivez dans ce vetuste laboratoire. la machine a caffe est cassee "), nl,
    write("M hyvernat est dans son bureau, il semble etre en train de reparer tplab"), nl,
    !.
decrire(quattreCanton):- temps_courant(futur),
    write("vous arrivez devant ces vieux batiments de l'universite"), nl,
    write("Ces batiments ont mieux vieillit que les autres.."), nl,
    write("on y appercoit M.Garet en train de cermoner les L1:"), nl,
    write("defaillant au tp, defaillant a l'UE, deffaillant au semestre, defaillant a l'annee, on est d'accord?"), nl,
    write("...on est d'accord."),
    write("il vous interpelle et vous dit:"),
    write("zizi"),
    nl,
    !.
decrire(huitB):- temps_courant(futur),
    write("dernier grand batiment de cette université qui n'a pas encore ete detruit"), nl,
    write("on y voit jol travailler sur son projet secret, le fameux c+++"), nl,
    !.
decrire(polytech):- temps_courant(futur),
    write("polytech est devenu un champ de ruine depuis les incidents du tp3 de logique"), nl,
    write("M.Wayntal est en train de develloper une progressive Web-app pour partir d'ici"), nl,
    !.

decrire(modele_osi):-position_courante(lama),temps_courant(present),
        write("un modele perdu dans les ages. Selon Maitre Bauzac"),nl,
        write("ce puissant arcane n'a pas ete implemente mais decrit les loi regissant l'internet"),nl,
        write("Ce modele pourrait interesser M.Garet"),nl.
%%Il faudrait amener l'algo de tri par bulle � hyvernat%%
decrire(tri_par_bulle):-position_courante(lama),temps_courant(present),
        write("Cet Algorithme de tri, bien que de complexit� constante n2"),nl,
        write("doit etre utilis� avec jugeotte! Dans le cas contraire"),nl,
        write("la situation risquerait de degenerer"),nl.
decrire(tri_par_bulle):-position(tri_par_bulle,vide),
        write("Vous donnez l'algorithme a M.Waytal"),nl,
        write("Vous le voyez ecrire des lignes de commandes"),nl,
        write("sudo Hack tri_par_bulle(liste_etu_2021_2022)"),nl.

%copies d'�tudiants%


%copies du temps pr�sent%
decrire(copies_partiels_logique):-
        write("Ces copies sont remplies de symboles incompr�hensibles."),nl,
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
        write("Ahh, les annees bissextiles.. je me rappelle de cette matiere.."),nl,
        write("Ce sont des copies d'info101'.. La bonne epoque"),nl.

decrire(copies_d_algorithmique):-
        write("Ces copies sont vierges.."),nl,
        write("Les eleves ne peuvent pas avoir tous rendu feuille blanche?.."),
        write("n'es-ce pas?.. n'es-ce pas??")nl.

decrire(copies_grammaire_automates):-
        write("Oulala j'ai jamais rien compris au regex moi!"),nl,
        write("Vivement la fin de l'année j'en peux plus moi de tout ça.."),nl,
        write("je préfèrerais faire une license option prolog"),nl. 