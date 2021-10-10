%%% INFO-501, TP2
%%% Enseignant Pierre Hyvernat
%%%Binome Delifer Paul Guesdon Theo
%%% Lancez la "requete"
%%% jouer.
%%% pour commencer une partie !
%

% il faut declarer les predicats "dynamiques" qui vont etre modifies par le programme.
:- dynamic position/2, position_courante/1.
:- dynamic doloreane/2, temps_courant/1.
:- dynamic position/3, position_courante/1.
:- dynamic nombre_de_copie/1.
% on remet a jours les positions des objets et du joueur
:- retractall(position(_, _)), retractall(position_courante(_)).
:- retractall(doloreane(_, _)), retractall(temps_courant(_)).
:- retractall(position_objets(_, _, _)), retractall(position_courante(_)).

% on declare des operateurs, pour autoriser `prendre torche` au lieu de `prendre(torche)`
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
        %est_dans_liste(X),
        utiliser(X),
        retract(temps_courant(Fromage)),
        assert(temps_courant(Temps)),
        regarder, !.
voyage(_,_):-write("la voiture n'est pas alimentée"), false, !. 
%%

% position du joueur. Ce predicat sera modifié au fur et a mesure de la partie (avec `retract` et `assert`)
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


% passages entre les different endroits du jeu

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

% position des objets%
%%
%parchemin 1 2 3%
position_objets(parchemin_1,lama,temps_courant(present)).
position_objets(parchemin_2,huitB,temps_courant(futur)).
position_objets(parchemin_3,quatrecanton,temps_courant(passe)).
%%
%code secret%
position_objets(code_secret_1, lama, passe).
position_objets(code_secret_2, polytech, present).
%modele osi
position_objets(modele_osi, lama, present).
%Tri par bulle obtenu apres avoir parle du modele osi a Mgaret%
position_objets(tri_par_bulle, lama, temps_courant(present)).
%resultat%
position_objets(resultat, polytech, temps_courant(futur)).
%copies des eleves%
position_objets(copies_pourraves,huitB, temps_courant(present)).
position_objets(copies_partiels_logique,quattreCanton, temps_courant(present)).

position_objets(copies_grammaire_automates,huitB, temps_courant(passe)).
position_objets(copies_systeme_dexploitation,huitB, temps_courant(passe)).

position_objets(copies_partiels_logique,lama, temps_courant(futur)).
position_objets(copies_dun_ancien_temps,huitB, temps_courant(futur)).
% ramasser un objet
prendre(X) :-
        position(X, en_main),
        write("Vous lavez deja !"), nl,
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
        write("Vous navez pas ea en votre possession !"), nl,
        fail.


% quelques raccourcis
n :- aller(nord).
s :- aller(sud).
e :- aller(est).
o :- aller(ouest).


% deplacements
aller(Direction) :-
        position_courante(Ici),
        passage(Ici, Direction, La),
        retract(position_courante(Ici)),
        assert(position_courante(La)),
        regarder, !.

aller(_) :-
        write("Vous ne pouvez pas aller par le."),
        fail.


%De%
% regarder autour de soi
regarder :-
        position_courante(Place),
        decrire(Place), nl,
        lister_objets(Place), nl.


% afficher la liste des objets e lemplacement donne
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
        write("Les commandes doivent etre donnees avec la syntaxe Prolog habituelle."), nl,
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
        write("Les licenses 3 ont foires leurs projets. L universite est desormais discreditee et"), nl,
        write("est devenue la risee de la communaute universitaire dans le domaine informatique"), nl,
        write("Plus aucune entreprise ne veut proposer de projets aux futurs etudiants de L3"), nl,
        write("Votre mission, Si vous l acceptez est de parcourir les differentes epoques"), nl,
        write("afin de retrouver les algorithmes de tri permettant d ecremer la license."), nl,nl,
        regarder.
% descriptions des emplacements du passe
decrire(usmb_cours) :- temps_courant(passe),
    write("vous vous retrouver en 1950"), nl,
    write("la base est remplie de soldat"), nl,
    !
    .

decrire(lama) :- temps_courant(passe),position(copies_pourraves,vide),
    write("tri par bulle vide"), nl,
    write(""), nl,
    !
    .
decrire(lama) :- temps_courant(passe),
    write("vous vous trouvez dans le nouveau laboratoire scientifique dernier cri"), nl,
    write("le fleuron des mathématiques françaises"), nl,
    write("vous parler a hyvernat l'étudiant qui revise ses cours de logique du premier ordre"), nl,
    write("il vous dit qu'il est sur un projet secret"),nl,
    write("ce projet pourrait transformer le plus null des étudiant en bosse des maths"), nl,
    write("'je ne connais que la moitier du code l'autre partie est detenue par Wayntal'"), nl,
    !
    .

decrire(quattreCanton) :- temps_courant(passe),
    write("Vous arrivez en 4 Canton, vous y appercevez des militaires se faisant cermoner par.."), nl,
    write("M. Garet ? Il est entrain de cermoner les nouvelles recrues.. Son speech me dit quelque chose.."), nl,
    write("Deserteur au menage. Deserteur au bataillon. Deserteur a l'armee. Deserteur au cachot"),nl,
    write("On est d'accord?"),nl,!.
decrire(polytech) :- temps_courant(passe),
    write("ne me parle pas je cherche un algo mal fait pour ma machine a calculer"), nl,!.

decrire(polytech) :- temps_courant(passe),position(tri_par_bulle,en_main),
    write("salut, mais c'est un superbe algo de tri que je vois la?! donne le moi ! j'en ai besoin pour trier les eleves par leurs moyenne!"),nl,
    write("Sacreubleux! La liste etait semi-triee ... l'algorithme degenere..'"),nl,
    write("Mon ordinateur ne repond plus... revient plus tard.. l'ordinateur aura peut-etre fini ses calculs.."),nl,!.

% descriptions des emplacements du present
decrire(usmb_cours) :- temps_courant(present),
    write("vous vous trouvez dans la cours de l usmb"), nl,
    write("vous appercevez marty, accompagne de son fidele compagnon le boussion-ardent, non loin de sa doloreane"), nl,!.

decrire(lama):- temps_courant(present),position(resultat,en_main),
        write("vous avez la nouvelle liste des etudiants? bravos prenez ceci, ce hashcode vous aidera dans votre quete"), nl,
        !
        .

decrire(lama):- temps_courant(present),
        write("Vous arrivez dans ce prestigieux laboratoire. Vous appercevez M. Hyvernat devant la machine a caffe"), nl,
        write("il arrive devant vous avec un papier a la main"),nl,
        write("il dit: je sais ce que tu fais, je peux détecter les anomalies logiques"), nl,
        write("tu joues a un jeu dangereux la fac n'as pas toujours été un lieu de paix"), nl,
        write("prend cet algo puisque tu te lances dans cette aventure! Vas donner ca a un etudiant de polytech promo:1950"), nl,
        !
        .

decrire(quattreCanton):-temps_courant(present),
        write("vous entrez dans en 4canton, vous appercevez garet faisant peur au l1"), nl,
        write("garet vous appercois et vous demande de venir"),nl,
        write("je sais ce que tu cherche je le possedait autrefois mais je lai perdu"),nl,
        write("si tu compte aller le chercher prends garde, je n'ai toujour été un simple prof"),nl,
        !
        .

decrire(huitB):-temps_courant(present),position(code_secret_1,en_main),position(code_secret_2,en_main),
        write("comment a tu eu ce code!?"), nl,
        write("tu ne dois pas rester la"), nl,
        write("je ne peux pas t'aider, ta seule chance c'est de revenir plus tard, bien plus tard"), nl,
        !
        .

decrire(huitB):-temps_courant(present),
        write("Vous arrivez dans les batiments 8B, Jacques-Olivier Lachaud dispense un cours de VISI201"), nl,
        write("Mieux vaut ne pas le deranger ces CMI ont l'air largués..."),nl,!.

decrire(polytech):-temps_courant(present),
        write("que fait tu ici?"), nl,
        write("comment ca sauver le monde"), nl,
        write("bon ecoute tu veux le code prend le moi je doit finir hive2"), nl,
        !
        .
%%%%%%%%%%%Description des emplacements du futur
decrire(usmb_cours) :- temps_courant(futur),
    write("vous etes dans la cours de l'usmb, cette cours est mal entretenu et des rat parcours la structure"), nl,
    write("vous appercevez marty, accompagne de son fidele compagnon le boussion-ardent, non loin de sa doloreane"), nl,
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
    write("Que faites vous-ici?"), write("n'étiez vous pas defailant après les incidents ayant reduit a neant la reputation de la fac?"),
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

decrire(polytech):- temps_courant(futur),position(tri_par_bulle,vide),
    write("Je vous attendais.."), nl,
    write("Mon ordinateur à terminé les calculs.. Prends ces resultats!"), nl,
    write("tu devrais aller voir M. Hyvernat a ton epoque immediatement"),!.

decrire(modele_osi):-position_courante(lama),temps_courant(present),
        write("un modele perdu dans les ages. Selon Maitre Bauzac"),nl,
        write("ce puissant arcane n'a pas ete implemente mais decrit les loi regissant l'internet"),nl,
        write("Ce modele pourrait interesser M.Garet"),nl.
%%Il faudrait amener lalgo de tri par bulle e hyvernat%%
decrire(tri_par_bulle):-position_courante(lama),temps_courant(present),
        write("Cet Algorithme de tri, bien que de complexite constante n2"),nl,
        write("doit etre utilise avec jugeotte! Dans le cas contraire"),nl,
        write("la situation risquerait de degenerer"),nl.

decrire(tri_par_bulle):-position(tri_par_bulle,vide),
        write("Vous donnez l'algorithme a M.Waytal"),nl,
        write("Vous le voyez ecrire des lignes de commandes"),nl,
        write("sudo Hack tri_par_bulle(liste_etu_2021_2022)> liste_triee"),nl.

decrire(resultat):-
    write("Ce sont les resultats du tri realise sur la liste des etudiants."),nl,
    write("je ne vois pas mon nom dessus? Ce doit etre une erreur.. n'es-ce pas?"),nl.
%copies detudiants%


%copies du temps present%
decrire(copies_partiels_logique):-
        write("Ces copies sont remplies de symboles incomprehensibles."),nl,
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
        write("n'es-ce pas?.. n'es-ce pas??"),nl.

decrire(copies_grammaire_automates):-
        write("Oulala j'ai jamais rien compris au regex moi!"),nl,
        write("Vivement la fin de l'année j'en peux plus moi de tout ça.."),nl,
        write("je préfèrerais faire une license option prolog"),nl.