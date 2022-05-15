% 11

%
% Greatest common divisor, Euclids algorithm

gcd(X, X, X).
gcd(X, Y, D):-
    X < Y,
    Z is Y - X,
    gcd(X, Z, D).

gcd(X, Y, D):-
    Y < X,
    Z is X - Y,
    gcd(Z, Y, D).


%
% Coprime integers

areCoprimes(X, Y):- gcd(X, Y, 1), !.

%
% Euler Function

% Example: eulerFunctionUp(36, N). -> N = 12.
eulerFunctionUp(Number, AmountOfCoPrimes):-
    eulerFunctionUp_(Number, 0, Number, AmountOfCoPrimes).
eulerFunctionUp_(1, AmountOfCoPrimes, _, AmountOfCoPrimes).
eulerFunctionUp_(NumberToCheck, CoPrimeCounter, Number, AmountOfCoPrimes):-
    NewNumberToCheck is NumberToCheck - 1,
    (areCoprimes(NewNumberToCheck, Number),
    NewCoPrimeCounter is CoPrimeCounter + 1,
    eulerFunctionUp_(NewNumberToCheck, NewCoPrimeCounter, Number, AmountOfCoPrimes)
    ;
    eulerFunctionUp_(NewNumberToCheck, CoPrimeCounter, Number, AmountOfCoPrimes)).



% Example: eulerFunctionDown(36,N). -> N = 12.
eulerFunctionDown(Number, AmountOfCoPrimes):- eulerFunctionDown_(1, 0, Number, AmountOfCoPrimes).
eulerFunctionDown_(Number, AmountOfCoPrimes, Number, AmountOfCoPrimes).
eulerFunctionDown_(NumberToCheck, CoPrimeCounter, Number, AmountOfCoPrimes):-
    areCoprimes(NumberToCheck, Number),
    NewCoPrimeCounter is CoPrimeCounter + 1,
    NewNumberToCheck is NumberToCheck + 1,
    eulerFunctionDown_(NewNumberToCheck, NewCoPrimeCounter, Number, AmountOfCoPrimes)
    ;
    NewNumberToCheck is NumberToCheck + 1,
    eulerFunctionDown_(NewNumberToCheck, CoPrimeCounter, Number, AmountOfCoPrimes).
