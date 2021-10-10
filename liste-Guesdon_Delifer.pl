contient([X | _], X).
contient([_ | L], X) :- contient(L, X).

deuxieme(X, []) :- fail.
deuxieme(X, [Y]) :- fail.
deuxieme(X, [Y, Z | L]) :- X = Z.

deuxieme2(X, [_, X | _]).
dernier(X,[X]).
dernier(X,[_|Z]) :- dernier(X,Z).

voisin(X, Y, [X,Y|_]).
voisin(X, Y, [_|Z]) :-voisin(X, Y, Z).

devant([_ | L], X, Y) :- devant(L, X, Y).
devant([X | L], X, Y) :- contient(L, Y).

