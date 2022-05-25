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
