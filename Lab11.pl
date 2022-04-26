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
