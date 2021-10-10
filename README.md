# TP2-prolog_jeuvx_video
jeux video, voyage dans la fac, tp2 prolog

theo guesdon
paul delifer


					################
					#	       #
					# TP1:PROLOGUE #
					#	       #
					################


#########################################
#	question 1-10			#
#########################################


QUESTION 1: ==========================================================================

1) l'instruction ?-chien(milou). renvoie true

2) l'instruction ?-mortel(louis_XIV). renvoie true

3) les instructions:
	?- chien(socrate).	--renvoie--> false
	?- chien(toto).		--renvoie--> false
	?- souris(milou).	--renvoie--> procedure `souris(A)' does not exist
ces reponse sont logiques, puisque:
socrate est définie comme philosophe et qu'il n'y a pas de lien entre philosophe et chien.
toto n'est définie nul part.
la procedure souris n'existe pas.

4)lorsque qu'on inscrit l'instruction mortel(x), prologue nous renvoie x = socrate
et nous propose de montrer plusieur ou tout les valeur de x pour lequel mortel(x) est vrai.
donc lorsque qu'on demande l'ensemble des valeurs de x, prologue renvoie:
X = socrate
X = louis_XIV
======================================================================================

QUESTION 2: ==========================================================================
Le résultat de ?-X=pere(theophile, louise). sera: 
X=pere(theophile, louise)

De meme pour pere(theophile, louise) = X donnera
X=pere(theophile, louise)
 
les deux lignes sont équivalentes !
======================================================================================

QUESTION 3: ==========================================================================
lorsqu'on fais le test de grand père sur l'arbre, il arrive parfois que la fonction
renvoie false alors qu'il sagit bien du grand-père. cela vient du code, en éffet pour
savoir si une personne est le grand pere d'une autre on test si il est le "père du père"
or, si le "grand-père" a eu une fille le test père/2 renvoie un false et donc la 
fonction grand-père renvois false mème si le resultat est vrai. 

nous décidons de corriger l'erreur et donc:
pour cefaire on rajoute un prédica qui propose de chercher dans le cas ou
le grand père a une fille. comme ceci:
grand_pere(GP,PF) :-
    pere(GP,F),
    mere(F,PF).

exemple:
-->avant la correction:
?- grand_pere(theophile,julie).
true .
-->après:
?- grand_pere(theophile,julie).
true .
======================================================================================

QUESTION 4: ==========================================================================
fratrie reussit a renvoyer les bons freres et soeurs, cependant fratrie renvoie qu'une personne est
sont propre frère ou soeur (car un individu à bel et bien le même père et la meme mère). pour eviter cela il faut que nous ajoutons une clause de négation, qui empêchera à prolog
de renvoyer le résultat quand X vaut X.

on teste alors la fonction fratrie avec " \+ X = Y," au début de la procedure fratrie.
Ce prédicat permets d'exclure le resultat lorsque lea frere/soeur.
Cependant lorsque l'union sur non X = Y est faite en début de fonction la fonction renvoie True et ne liste plus la fratrie avec les parametres fratrie(nomdunfrangin,X).
on a l'idée de poser "\+ X = Y," en fin de fratrie.
Dans ce cas la fonction marche dans
tous les cas et ne revoie pas qu'une personne est son/sa frère/soeur.
======================================================================================

QUESTION 5: ==========================================================================
On teste les deux definitions de deuxieme/2.
Les résultats sont ci-dessous.
?- deuxieme2(X, [2, 6, 8]).
X = 6.

?- deuxieme(X, [2, 6, 8]).
X = 6.

?- deuxieme(X, []).
false.

?- deuxieme2(X, []).
false.
======================================================================================

QUESTION 6: ==========================================================================
1) contient fait un test récursif, ou il test si le premier élément de la liste est 
égale a x, si oui il renvoie vrai sinon, il retest mais en enlevent le première élément 
de la liste. et renvera faux si la liste est vide, car si la liste est vide on en déduit
qu'il n'y a aucun élément dans la liste qui est égale a x.

2) fait dans list-Guesdon_Delifer.pl

3) fait dans list-Guesdon_Delifer.pl

4) fait dans list-Guesdon_Delifer.pl

======================================================================================

QUESTION 7: ==========================================================================
2)
Avantages:
    - Ne parcours pas toute la liste pour dire si un élement est contenu dans une liste
    - Empêche les récursions infini
  Désavantage: 
    - ne parcours que le premier élement de la liste.
3)
menbre/2:
    contient1(A,[A|_]).
    contient1(A,[_|L]) :- contient1(A,L).
======================================================================================

QUESTION 8: ==========================================================================

======================================================================================

QUESTION 9: ==========================================================================

======================================================================================

#########################################
#	question 11 / le jeu		#
#########################################



