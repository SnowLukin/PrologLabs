% -------- 11 --------

%
% Greatest common divisor, Euclids algorithm

gcd(0, X, X):- !.
gcd(X, 0, X):- !.
gcd(X, X, X):- !.
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

areCoprimes(X, Y):-
    gcd(X, Y, Result),
    1 is Result.

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


% -------- 12 --------

%
% Divider that is coprime with most digits of the Number
/*
    Example:
        ?- getDividerMaxAmountOfDigitsCoPrime(10, X).
        List of Dividers: [1,2,5,10]
        List of Digits: [1,0]
        X = 1
*/

isDivider(Number, Divider):- Mod is Number mod Divider, 0 is Mod.

getDividers(Number, DividersList):- getDividers(Number, Number, [], DividersList).
getDividers(_, 0, List, ResultList):- ResultList = List.
getDividers(Number, Divider, List, ResultList):-
    isDivider(Number, Divider),
    append([Divider], List, NewList),
    NewDivider is Divider - 1,
    getDividers(Number, NewDivider, NewList, ResultList);
    NewDivider is Divider - 1,
    getDividers(Number, NewDivider, List, ResultList).

getDigits(Number, List):- getDigits(Number, [], List).
getDigits(0, _, ResultList):- ResultList = [].
getDigits(Number, List, ResultList):-
    Number < 10,
    Mod is Number mod 10,
    append([Mod], List, NewList),
    ResultList = NewList.
getDigits(Number, List, ResultList):-
    Mod is Number mod 10,
    Div is Number div 10,
    append([Mod], List, NewList),
    getDigits(Div, NewList, ResultList).

countCoprimesForNumber(Number, List, Result):-
    include(areCoprimes(Number), List, ResultList),
    length(ResultList, Length),
    Result is Length.

getDividerMaxAmountOfDigitsCoPrime(DividersList, DigitsList, Result):-
    getDividerMaxAmountOfDigitsCoPrime(DividersList, DigitsList, -1, 0, Result).
getDividerMaxAmountOfDigitsCoPrime([], _, _, Number, Result):- Result is Number.
getDividerMaxAmountOfDigitsCoPrime([Head|Tail], List, Max, Number, Result):-
    countCoprimesForNumber(Head, List, CoPrimes),
    CoPrimes > Max,
    NewMax is CoPrimes,
    NewNumber is Head,
    getDividerMaxAmountOfDigitsCoPrime(Tail, List, NewMax, NewNumber, Result);
    getDividerMaxAmountOfDigitsCoPrime(Tail, List, Max, Number, Result).
getDividerMaxAmountOfDigitsCoPrime([_|Tail], List, Max, Number, Result):-
    getDividerMaxAmountOfDigitsCoPrime(Tail, List, Max, Number, Result).
    
getDividerMaxAmountOfDigitsCoPrime(Number, Result):-
    getDividers(Number, DividersList),
    write('List of Dividers: '),
    writeln(DividersList),
    getDigits(Number, DigitsList),
    write('List of Digits: '),
    writeln(DigitsList),
    getDividerMaxAmountOfDigitsCoPrime(DividersList, DigitsList, ResultDivider),
    Result is ResultDivider.
    

