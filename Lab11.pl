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


%grandDaughter(X,Y):- parent(Z,X), parent(Y,Z), woman(X).
%wife(X,Y):- grandDaughter(Z,Y), parent(X,Z).

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

% Extra task

couple(X,Y):-
    woman(Y),
    parent(X,Z),
    parent(Y,Z).

brother(X,Y):- man(X), parent(Z,Y), parent(Z,X).

shurin(X, Y):- couple(X,Z), brother(Y, Z).

husbandsFather(X,Y):- couple(X,Z), man(Z), parent(Y,Z).


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
    
% 11.18
% getSumOfDigitsMod3Down(329,Y).  -> Y = 12
getSumOfDigitsMod3Down(X,Y,Z):-
    X < 10,
    Mod is X mod 3,
    (0 is Mod, Y is Z + X ; Y is Z).
getSumOfDigitsMod3Down(X,Y,Z):-
    Mod is X mod 10,
    Div is X div 10,
    Remainder is Mod mod 3,
    (0 is Remainder, NewZ is Remainder + Z; NewZ is Z),
    getSumOfDigitsMod3Down(Div,Y,NewZ).
getSumOfDigitsMod3Down(X,Y):- getSumOfDigitsMod3Down(X,Y,0).

% 11.19
% fibonacciUp(4,X).  -> X = 3
fibonacciUp(Index,Number) :- Index < 3, Number is 1.
fibonacciUp(Index,Number) :-
    PreviousIndex is Index - 1, PrePreviousIndex is Index - 2,
    fibonacciUp(PreviousIndex,PreviousNumber),
    fibonacciUp(PrePreviousIndex,PrePreviousNumber),
    Number is PreviousNumber + PrePreviousNumber.

% 11.20
% fibonacciDown(4,X).  -> X = 3
fibonacciDown(0,X,LX,PLX):- X is LX + PLX.
fibonacciDown(N,X,_,_):- N < 0, X is 1.
fibonacciDown(N,X,LX,PLX):-
    NewN is N - 1,
    NLX is LX + PLX,
    NPLX is LX,
    fibonacciDown(NewN,X,NLX,NPLX).
fibonacciDown(N,X):- N1 is N - 2, fibonacciDown(N1,X,1,0).
