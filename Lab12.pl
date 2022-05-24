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

isDivider(Number, Divider):-
    0 \= Divider,
    Mod is Number mod Divider,
    0 is Mod; false, !.

getDividers(Number, DividersList):- getDividers(Number, Number, [], DividersList), !.
getDividers(_, 0, List, ResultList):- ResultList = List, !.
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
    

% -------- 13 --------

getAmountOfDividers(Number, Result):-
    getDividers(Number, DividersList),
    length(DividersList, Length),
    Result is Length.

isPrime(1):- false, !.
isPrime(Number):- Number < 1, false.
isPrime(Number):-
    getAmountOfDividers(Number, AmountOfDividers),
    AmountOfDividers < 3; false.

isNotPrime(1):- true, !.
isNotPrime(Number):- Number < 1, true.
isNotPrime(Number):-
    getAmountOfDividers(Number, AmountOfDividers),
    AmountOfDividers > 2; true.

cutLeft(Number):- Number < 10, isPrime(Number), !.
cutLeft(Number):-
    isPrime(Number),
    Div is Number div 10,
    cutLeft(Div), !;
    false, !.

% WTF is this Prolog?! Who the hell made it so complicated
cutRight(Number):-
    cutRight__(Number, Result), NewResult is Result, 1 is NewResult.
cutRight__(Number, Result):- cutRight_(Number, Result), !.
cutRight_(Number, Result):-
    Number < 10,
    (isPrime(Number), Result is 1; Result is 0), !.
cutRight_(Number, Result):-
    isPrime(Number),
    getDigits(Number, DigitsList),
    length(DigitsList, Length),
    NewLength is Length - 1,
    SubLength is 10 ** NewLength,
    Mod is Number mod SubLength,
    cutRight_(Mod, Result);
    Result is 0, !.

task14(Number, Result):- task14(Number, 0, Result), !.
task14(0, Counter, Result):- Result is Counter.
task14(Number, Counter, Result):-
    cutLeft(Number),
    cutRight(Number),
    writeln(Number),
    NewNumber is Number - 1,
    NewCounter is Counter + 1,
    write('Counter: '),
    writeln(Counter),
    task14(NewNumber, NewCounter, Result);
    writeln(Number),
    NewNumber is Number - 1,
    task14(NewNumber, Counter, Result).


% -------- 14 --------

listLength(List, Result):- listLength(List, 0, Result), !.
listLength([], Counter, Result):- Result is Counter.
listLength([_|Tail], Counter, Result):-
    NewCounter is Counter + 1,
    listLength(Tail, NewCounter, Result).


% -------- 15.7 --------

% read_list(+N,-List)
read_list(0,[]):-!.
read_list(N,[H|T]):- read(H),
    Nmines1 is N - 1, read_list(Nmines1,T).

% write_list(+list)
write_list([]):-!.
write_list([H|T]):- write(H),write(' '), write_list([T]).

mergeLists([], List, List).
mergeLists([Head|Tail], List, [Head|ResultTail]):-
    mergeLists(Tail, List, ResultTail).

moveToLeft([H|T], R):- mergeLists(T, [H], R).

moveToRight(List, 0, Result):- Result = List, !.
moveToRight(List, Movements, Result):-
    moveToLeft(List, NewList),
    NewMovements is Movements - 1,
    moveToRight(NewList, NewMovements, Result).
    
doRotationsToRight(List, 0, Result):- Result = List, !.
doRotationsToRight(List, Rotations, Result):-
    listLength(List, Length),
    Movements is Length - 1,
    rotation(List, Movements, NewList),
    NewRotations is Rotations - 1,
    doRotationsToRight(NewList, NewRotations, Result).
    
    
% -------- 15.8 --------

%   Дан целочисленный массив. Необходимо найти индексы двух наименьших элементов массива.

getMinElementIndex([Head|Tail], Index):- getMinElementIndex(Tail, Head, 0, 0, Index), !.
getMinElementIndex([], _, _, MinIndex, Index):- Index is MinIndex.
getMinElementIndex([Head|Tail], Min, CurrentIndex, MinIndex, Index):-
    Head < Min,
    NewCurrentIndex is CurrentIndex + 1,
    NewMinIndex is NewCurrentIndex,
    getMinElementIndex(Tail, Head, NewCurrentIndex, NewMinIndex, Index);
    NewCurrentIndex is CurrentIndex + 1,
    getMinElementIndex(Tail, Min, NewCurrentIndex, MinIndex, Index).

getElementAtIndex(List, Index, Element):- getElementAtIndex(List, Index, 0, Element), !.
getElementAtIndex([], _, _, Element):- Element is 0.
getElementAtIndex([Head|Tail], Index, CurrentIndex, Element):-
    CurrentIndex is Index,
    Element is Head;
    NewCurrentIndex is CurrentIndex + 1,
    getElementAtIndex(Tail, Index, NewCurrentIndex, Element).

removeFromList(Element, List, Result):- removeFromList_(Element, List, Result), !.
removeFromList_( _, [], []).
removeFromList_(Element, [Element|Tail], Tail).
removeFromList_(Element, [Head|Tail], [Head|ResultTail]):-
    Head \= Element,
    removeFromList_(Element, Tail, ResultTail).

getIndexesOfMinElements([], _):- !.
getIndexesOfMinElements(_, AmountOfMin):- AmountOfMin < 1, !.
getIndexesOfMinElements(List, AmountOfMin):-
    getMinElementIndex(List, Index),
    write(Index), write(' '),
    NewAmountOfMin is AmountOfMin - 1,
    getElementAtIndex(List, Index, Element),
    removeFromList(Element, List, NewList),
    getIndexesOfMinElements(NewList, NewAmountOfMin).
