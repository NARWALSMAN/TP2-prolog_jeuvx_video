euxieme(X, [_, X | _]).
voisins([X, Y | _], X, Y).
voisins([Y, X | _], X, Y).
voisins([_ | L], X, Y) :- voisins(L, X, Y).

devant([X | L], X, Y ) :- contient(L,Y).
devant([_ | L], X, Y ) :- devant(L,X,Y).

solution(L) :-
    L = [_,_,_,_],           %tableau des 4cartes

    member(L, pique),       % la solution contient as de pique
    member(L, coeur),       %                         as de coeur
    member(L, trefle),      %                         as de trefle
    member(L, carreau),     %                         as de carreau

    % en position 2, il n y a ni las de trefle, ni l as de pique
    \+deuxieme(pique, L),
    \+deuxieme(trefle, L),

    % l as de trefle est plus a droite que l as de carreau
    devant(L, carreau, trefle),

    % l as de carreau et l as de coeur ne sont pas voisins
    \+voisins(L, carreau, coeur).