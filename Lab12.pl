% 11

% greatest common divisor, Euclids algorithm
gcd(X, X, X).
gcd(X, Y, D):-
    X < Y,
    Z is Y - X,
    gcd(X, Z, D).
gcd(X, Y, D):-
    Y < X,
    Z is X - Y,
    gcd(Z, Y, D).

% Coprime integers
areCoprimes(X, Y):- gcd(X, Y, 1), !.

% Euler Function
% Example: eulerFunction(36,N). -> N = 12.
eulerFunction(Number, AmountOfCoPrimes):- eulerFunction_(1, 0, Number, AmountOfCoPrimes).
eulerFunction_(Number, AmountOfCoPrimes, Number, AmountOfCoPrimes).
eulerFunction_(NumberToCheck, CoPrimeCounter, Number, AmountOfCoPrimes):-
    areCoprimes(NumberToCheck, Number),
    NewCoPrimeCounter is CoPrimeCounter + 1,
    NewNumberToCheck is NumberToCheck + 1,
    eulerFunction_(NewNumberToCheck, NewCoPrimeCounter, Number, AmountOfCoPrimes)
    ;
    NewNumberToCheck is NumberToCheck + 1,
    eulerFunction_(NewNumberToCheck, CoPrimeCounter, Number, AmountOfCoPrimes).
