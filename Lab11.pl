man(mason).
man(maverick).
man(maddox).
man(michael).
man(madison).
man(matthew).

woman(mona).
woman(maya).
woman(mia).
woman(mary).
woman(maria).
woman(mila).

parent(mason, maverick).
parent(mona, maverick).

parent(michael, maya).
parent(michael, madison).

parent(mia, maya).
parent(mia, madison).

parent(matthew, maria).
parent(mila, maria).

parent(maverick, maddox).
parent(maya, maddox).

parent(madison, mary).
parent(maria, mary).

%11.11
son(X,Y):- parent(Y,X), man(X).
son(X):- parent(X,Y), man(Y), write(Y), nl.

%11.12
sister(X,Y):- parent(Z,X), parent(Z,Y), woman(X).
sister(X):- sister(Y,X), woman(Y), write(Y), nl.

%11.13
grandson(X,Y):- parent(Z,X), parent(Y,Z), man(X).
grandsons(X):- grandson(Y,X),write(Y), nl.

%11.14
grandpa_daughter(X,Y):-
parent(X,Z), parent(Z,Y), woman(Y), man(X) |
parent(Y,Z), parent(Z,X), woman(X), man(Y).

%11.15
maxRecUp(X, X):- X < 10, !.
maxRecUp(X, Max):-
   Xdiv is X div 10,
   Xmod is X mod 10,
   maxRecUp(Xdiv, NewMax),
   (Xmod < NewMax, Max is NewMax; Max is Xmod).


%11.16
maxRecDown(X, Max):- maxRecDown(X, 0, Max).
maxRecDown(0, Max, Max):- !.
maxRecDown(X, C, Max):-
    X1 is X div 10,
    D1 is X mod 10,
    D1 > C,
    !,
    maxRecDown(X1, D1, Max);
    X2 is X div 10,
    maxRecDown(X2, C, Max).

% 11.17
% getSumOfDigitsMod3Up(329,Y).  -> Y = 12
getSumOfDigitsMod3Up(X,Y):-
    X < 10,
    Remainder is X mod 3,
    (0 is Remainder, Y is X ; Y is 0).
getSumOfDigitsMod3Up(X,Y):-
    Div is X div 10,
    Mod is X mod 10,
    Remainder is Mod mod 3,
    (0 is Remainder, getSumOfDigitsMod3Up(Div, C), Y is Mod + C ; getSumOfDigitsMod3Up(Div, Y)).
    
