listContains([],_):- false, !.
listContains([Head|_],Head).
listContains([_|Tail],Number):- listContains(Tail,Number).

mergeLists([], List, List).
mergeLists([Head|Tail], List, [Head|ResultTail]):-
    mergeLists(Tail, List, ResultTail).

buildList(From, To, Result):- buildList(From, To, From, [], Result), !.
buildList(_, To, To, List, Result):- mergeLists(List, [To], NewList), Result = NewList.
buildList(From, To, CurrentNumber, List, Result):-
    mergeLists(List, [CurrentNumber], NewList),
    NewCurrentNumber is CurrentNumber + 1,
    buildList(From, To, NewCurrentNumber, NewList, Result).

removeFromList(Element, List, Result):- removeFromList_(Element, List, Result), !.
removeFromList_( _, [], []).
removeFromList_(Element, [Element|Tail], Tail).
removeFromList_(Element, [Head|Tail], [Head|ResultTail]):-
    Head \= Element,
    removeFromList_(Element, Tail, ResultTail).

removeIdentical([], List, Result):- Result = List, !.
removeIdentical([Head|Tail], List, Result):-
    removeFromList(Head, List, NewList),
    removeIdentical(Tail, NewList, Result).

contains([], _):- false, !.
contains([Head|Tail], Number):-
    Head is Number,
    true, !;
    contains(Tail, Number).

getElementsContainedInList(List, Segment, Result):-
    getElementsContainedInList(List, Segment, [], Result), !.
getElementsContainedInList([], _, List, Result):- Result = List.
getElementsContainedInList([Head|Tail], Segment, List, Result):-
    contains(Segment, Head),
    mergeLists(List, [Head], NewList),
    getElementsContainedInList(Tail, Segment, NewList, Result);
    getElementsContainedInList(Tail, Segment, List, Result).

listLength(List, Result):- listLength(List, 0, Result), !.
listLength([], Counter, Result):- Result is Counter.
listLength([_|Tail], Counter, Result):-
    NewCounter is Counter + 1,
    listLength(Tail, NewCounter, Result).

listSum(List, Result):- listSum(List, 0, Result), !.
listSum([], Result, Result).
listSum([Head|Tail], Sum, Result):-
    NewSum is Sum + Head,
    listSum(Tail, NewSum, Result).

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

getAmountOfDividers(Number, Result):-
    getDividers(Number, DividersList),
    listLength(DividersList, Length),
    Result is Length.

isPrime(1):- false, !.
isPrime(Number):- Number < 1, false.
isPrime(Number):-
    getAmountOfDividers(Number, AmountOfDividers),
    AmountOfDividers < 3; false.

primeList(List, Result):- primeList(List, [], Result), !.
primeList([], Result, Result).
primeList([Head|Tail], List, Result):-
    isPrime(Head),
    mergeLists(List, [Head], NewList),
    primeList(Tail, NewList, Result);
    primeList(Tail, List, Result).

elementsHigherThanNumber(List, Number, Result):- elementsHigherThanNumber(List, Number, [], Result), !.
elementsHigherThanNumber([], _, Result, Result).
elementsHigherThanNumber([Head|Tail], Number, List, Result):-
    Head > Number,
    mergeLists(List, [Head], NewList),
    elementsHigherThanNumber(Tail, Number, NewList, Result);
    elementsHigherThanNumber(Tail, Number, List, Result).

% ------- 1.38 -------

% Дан целочисленный массив и отрезок a..b. Необходимо найти количество элементов, значение которых принадлежит этому отрезку.

/*
    Example:
        task1_38([1,2,3,4,5,6,7,8],3,7,X).
        X = [3, 4, 5, 6, 7].
*/
    
task1_38(List, From, To, Result):-
    buildList(From, To, Segment),
    getElementsContainedInList(List, Segment, NewList),
    Result = NewList, !.

% ------- 1.44 -------
/*
    Example:
        ?- task1_44([1,2.2,4,5,7,8.8]).
        Do NOT Interchange
        true.

        ?- task1_44([1,2.2,4,5.1,7,8.8]).
        Do Interchange
        true.
*/

task1_44([X,Y|Tail]):-
    integer(X),
    float(Y),
    mergeLists([Y], Tail, NewList),
    task1_44(NewList), !.
task1_44([X,Y|Tail]):-
    float(X),
    integer(Y),
    mergeLists([Y], Tail, NewList),
    task1_44(NewList), !.
task1_44([X,Y|_]):- integer(X), integer(Y), write('Do NOT Interchange'), !.
task1_44([X,Y|_]):- float(X), float(Y), write('Do NOT Interchange'), !.
task1_44(_):- write('Do Interchange'), !.

    
% ------- 1.56 -------

% Для введенного списка посчитать среднее арифметическое непростых
% элементов, которые больше, чем среднее арифметическое простых.

/*
    Example:
        ?- task1_56([1,2,3,4,5,6,7,8,9,10,11],X).
        Prime list: [1,2,3,5,7,11]
        Prime list length: 6
        Prime list sum: 29
        Prime Average: 4.833333333333333
        Not Prime list: [4,6,8,9,10]
        Updated Not Prime list: [6,8,9,10]
        X = 8.25.
*/
    
task1_56(List, Result):-
    primeList(List, PrimeList),
    write("Prime list: "), writeln(PrimeList),
    listLength(PrimeList, PrimeLength),
    write("Prime list length: "), writeln(PrimeLength),
    listSum(PrimeList, PrimeSum),
    write("Prime list sum: "), writeln(PrimeSum),
    PrimeAverage is PrimeSum / PrimeLength,
    write("Prime Average: "), writeln(PrimeAverage),
    removeIdentical(PrimeList, List, NotPrimeList),
    write("Not Prime list: "), writeln(NotPrimeList),
    elementsHigherThanNumber(NotPrimeList, PrimeAverage, NewNotPrimeList),
    write("Updated Not Prime list: "), writeln(NewNotPrimeList),
    listLength(NewNotPrimeList, NotPrimeLength),
    listSum(NewNotPrimeList, NotPrimeSum),
    NotPrimeAverage is NotPrimeSum / NotPrimeLength, Result is NotPrimeAverage.
    
    
% ------- 14 -------

% Беседует трое друзей: Белокуров, Рыжов, Чернов. Брюнет
% сказал Белокурову: “Любопытно, что один из нас блондин, другой брюнет,
% третий - рыжий, но ни у кого цвет волос не соответствует фамилии”. Какой
% цвет волос у каждого из друзей?

task14(Result):-
    List = [_,_,_],
    listContains(List,[belokurov, _]),
    listContains(List,[chernov, _]),
    listContains(List,[rizhov, _]),
    listContains(List,[_, red]),
    listContains(List,[_, blond]),
    listContains(List,[_, brunette]),
    not(listContains(List,[belokurov,blond])),
    not(listContains(List,[chernov,brunette])),
    not(listContains(List,[rizhov,red])),
    Result = List, !.

% ------- 15 -------

% Три подруги вышли в белом, зеленом и синем платьях и туф-
% лях. Известно, что только у Ани цвета платья и туфлей совпадали. Ни туфли,
% ни платье Вали не были белыми. Наташа была в зеленых туфлях. Определить
% цвета платья и туфель на каждой из подруг.

task15(Result):-
    List = [_, _, _],
    listContains(List,[ann, _, _]),
    listContains(List,[valya, _, _]),
    listContains(List,[natasha, _, _]),
    listContains(List,[_, white, _]),
    listContains(List,[_, green, _]),
    listContains(List,[_, blue, _]),
    listContains(List,[_, _, white]),
    listContains(List,[_, _, green]),
    listContains(List,[_, _, blue]),
    listContains(List,[natasha, _, green]),
    not(listContains(List,[valya, white, white])),
    not(listContains(List,[natasha, green, _])),
    Result = List, !.

% ------- 16 -------

% На заводе работали три друга: слесарь, токарь и сварщик. Их
% фамилии Борисов, Иванов и Семенов. У слесаря нет ни братьев, ни сестер. Он
% самый младший из друзей. Семенов, женатый на сестре Борисова, старше то-
% каря. Назвать фамилии слесаря, токаря и сварщика.

% [профессия, фамилия, кол-во сестер, старшинство, жена]

/*
    Слесарь не Борисов (у борисова сестра, у слесаря нет)
    Слесарь не Семенов (слесарь самый младший, а Семенов старше токаря)
    -> Слесарь - Иванов

    Семенов старше токаря -> Токарь не Семенов
    -> Токарь - Борисов
    -> Сварщик - Семенов
*/

task16:-
    Workers = [_, _, _],
    
    listContains(Workers,[locksmith,    _,    0, 0,    _   ]),
    listContains(Workers,[turner,       _,    _, 1,    _   ]),
    listContains(Workers,[welder,       _,    _, _,    _   ]),
    listContains(Workers,[_,         semenov, _, 2, borisov]),
    listContains(Workers,[_,          ivanov, _, _,    _   ]),
    listContains(Workers,[_,         borisov, 1, _,    _   ]),
    
    listContains(Workers,[locksmith, Locksmith, _, _, _]),
    listContains(Workers,[turner, Turner, _, _, _]),
    listContains(Workers,[welder, Welder, _, _, _]),
    
    write('Locksmith: '), writeln(Locksmith),
    write('Turner: '), writeln(Turner),
    write('Welder: '), writeln(Welder), !.

% ------- 17 -------

% В бутылке, стакане, кувшине и банке находятся молоко, ли-
% монад, квас и вода. Известно, что вода и молоко не в бутылке, сосуд с лимона-
% дом находится между кувшином и сосудом с квасом, в банке - не лимонад и не
% вода. Стакан находится около банки и сосуда с молоком. Как распределены
% эти жидкости по сосудам.

isOnRight(_, _, [_]):- false, !.
isOnRight(A, B, [A|[B|_]]).
isOnRight(A, B, [_|List]):- isOnRight(A,B,List).

isOnLeft(_, _, [_]):- false, !.
isOnLeft(A, B, [B|[A|_]]).
isOnLeft(A, B, [_|List]):- isOnLeft(A,B,List).

next(A, B, List):- isOnRight(A, B, List).
next(A, B, List):- isOnLeft(A, B, List).

task17(Result):-
    Drinks = [_,_,_,_],
    
    listContains(Drinks,[bottle, _]),
    listContains(Drinks,[glass, _]),
    listContains(Drinks,[ewer, _]),
    listContains(Drinks,[jar, _]),
    listContains(Drinks,[_, milk]),
    listContains(Drinks,[_, lemonade]),
    listContains(Drinks,[_, kvas]),
    listContains(Drinks,[_, water]),
    
    % Вода и молоко не в бутылке
    not(listContains(Drinks,[bottle, milk])),
    not(listContains(Drinks,[bottle, water])),
    
    % В банке - не лимонад и не вода
    not(listContains(Drinks,[jar, lemonade])),
    not(listContains(Drinks,[jar, water])),
    
    % Сосуд с лимонадом находится между кувшином и сосудом с квасом
    isOnRight([ewer, _], [_, lemonade], Drinks),
    isOnRight([_, lemonade], [_, kvas], Drinks),
    
    % Стакан находится около банки и сосуда с молоком
    next([glass, _], [jar, _], Drinks),
    next([glass, _],[_, milk], Drinks),
    
    Result = Drinks, !.


% ------- 18 -------

/*
    Воронов, Павлов, Левицкий и Сахаров – четыре талантливых
    молодых человека. Один из них танцор, другой художник, третий - певец,
    а четвертый-писатель. О них известно следующее: Воронов и Левицкий
    сидели в зале консерватории в тот вечер, когда певец дебютировал в сольном
    концерте. Павлов и писатель вместе позировали художнику. Писатель написал
    биографическую повесть о Сахарове и собирается написать о Воронове.
    Воронов никогда не слышал о Левицком. Кто чем занимается?
*/

task18(Result):-
    Guys = [_, _, _, _],
    
    listContains(Guys, [voronov, _]),
    listContains(Guys, [pavlov, _]),
    listContains(Guys, [levizkyi, _]),
    listContains(Guys, [saharov, _]),
    listContains(Guys, [_, dancer]),
    listContains(Guys, [_, artist]),
    listContains(Guys, [_, singer]),
    listContains(Guys, [_, writer]),
    
    % Певец - не Воронов или Левицкий
    not(listContains(Guys, [voronov, singer])),
    not(listContains(Guys, [levizkyi, singer])),
    
    % Художник - не Павлов
    not(listContains(Guys, [pavlov, artist])),

    % Писатель - не Сахоров, Воронов, Павлов
    not(listContains(Guys, [saharov, writer])),
    not(listContains(Guys, [voronov, writer])),
    not(listContains(Guys, [pavlov, writer])),

    Result = Guys, !.
