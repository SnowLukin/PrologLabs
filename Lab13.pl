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

    
