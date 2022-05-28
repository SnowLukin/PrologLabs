writeList([]):- writeln(""), !.
writeList([Head|Tail]):-
    write(Head), write(" "),
    writeList(Tail).

readString(Str,N):-
    get0(Char),
    readString(Char, [], 0, Str, N, _).

readString(Str,N, Flag):-
    get0(Char),
    readString(Char, [], 0, Str, N, Flag).

readString(-1,Str,N,Str,N,1):-!.
readString(10,Str,N,Str,N,0):-!.

readString(Char,NowStr,Count,Str,N, Flag):-
    NewCount is Count+1,
    appendString(NowStr,[Char],NewNowStr),
    get0(NewChar),
    readString(NewChar,NewNowStr,NewCount,Str,N, Flag).

appendString([],X,X).
appendString([X|T],Y,[X|T1]) :- appendString(T,Y,T1).

writeString([]):-!.
writeString([H|T]):-put(H),writeString(T).

% --------- 1.1 ---------

% Дана строка. Вывести ее три раза через запятую и показать количество символов в ней.
/*
    Example:
        ?- task1_1(hello).
        h e l l o
        Lenght: 5
        true.
*/

task1_1(String):-
    atom_chars(String, CharList),
    writeList(CharList),
    length(CharList, Length),
    write("Lenght: "), writeln(Length).

% --------- 1.2 ---------

% Дана строка. Найти количество слов.
/*
    Example:
        ?- task1_2("somebody once told me").
        Amount of words: 4
        true.
*/

isSpace(Char):-
    atom_string(Char, NewChar),
    32 is NewChar, !.

task1_2(String):-
    atom_chars(String, CharList),
    include(isSpace, CharList, FilteredList),
    length(FilteredList, Length),
    AmountOfWords is Length + 1,
    write("Amount of words: "), writeln(AmountOfWords).

% --------- 1.3 ---------

% Дана строка, определить самое частое слово

/*
    Example:
        ?- task1_3.
        |: one two one three two one .
        one
        true.
*/

task1_3:-
    readString(String, _),
    mostCommonWord(String, MostCommonWord),
    writeString(MostCommonWord).

countWordString(List, X, Result):-
    countWordString(List, X, 0, Result).
countWordString([], _, Result, Result):- !.
countWordString([X|T], X, Count, Result):-
    NewCount is Count + 1,
    countWordString(T, X, NewCount, Result),!.
countWordString([_|T], X, Count, Result):-
    countWordString(T, X, Count, Result),!.

splitString([], _, CurWord, CurWordList, Result) :-
    appendString(CurWordList, [CurWord], NewWL),
    Result = NewWL,!.
splitString([Separator|T], Separator, CurWord, CurWordList, Result) :-
    appendString(CurWordList, [CurWord], NewWL),
    splitString(T, Separator, [], NewWL, Result),!.
splitString([S|T], Separator, CurWord, CurWordList, Result) :-
    appendString(CurWord, [S], NewWord),
    splitString(T, Separator, NewWord, CurWordList, Result),!.
splitString(Str, Separator, Result) :-
    char_code(Separator, SepCode),
    splitString(Str, SepCode, [], [], Result).

mostCommonWord(Str, Result) :-
    splitString(Str, " ", Words),
    mostCommonWord(Words, Words, 0, [], Result).
mostCommonWord(Words, [Word|T], CurMaxCnt, _, Result) :-
    countWordString(Words, Word, Cnt),
    Cnt > CurMaxCnt,
    NewMax is Cnt,
    NewMaxWord = Word,
    mostCommonWord(Words, T, NewMax, NewMaxWord, Result),!.
mostCommonWord(Words, [_|T], CurMaxCnt, CurMaxWord, Result) :-
    mostCommonWord(Words, T, CurMaxCnt, CurMaxWord, Result), !.
mostCommonWord(_, [], _, Result, Result) :-!.


% --------- 1.4 ---------

% Дана строка. Вывести первые три символа и последний три символа,
% если длина строки больше 5 Иначе вывести первый символ столько
% раз, какова длина строки.

/*
    Example:
        ?- task1_4.
        |: somebody
        som ody
        true.

        ?- task1_4.
        |: some
        ssss
        true.
*/

task1_4 :- readString(Str, N), task1_4(Str, N).
task1_4(Str, Lenght) :-
    Lenght > 5,
    subString(Str, 0, 3, First3),
    L3 is Lenght - 3,
    subString(Str, L3, Lenght, Last3),
    writeString(First3),
    write(" "),
    writeString(Last3),!.
task1_4([H|_], N) :- writeStringNTimes([H], N).

subString([H|T], Start, End, Ans) :-
    subString([H|T], Start, End, 0, [], Ans).

subString([H|T], Start, End, I, List, Ans) :-
    I >= Start, I < End,
    appendString(List, [H], NewList),
    NewI is I + 1,
    subString(T, Start, End, NewI, NewList, Ans),!.

subString([_|T], Start, End, I, List, Ans) :-
    NewI is I + 1,
    subString(T, Start, End, NewI, List, Ans),!.

subString([], _, _, _, Ans, Ans) :- !.

writeStringNTimes(_, 0) :- !.
writeStringNTimes(Str, N) :-
    writeString(Str),
    NewN is N - 1,
    writeStringNTimes(Str, NewN),!.


% --------- 1.5 ---------

% Дана строка. Показать номера символов, совпадающих с последним
% символом строки.

/*
    Example:
        ?- task1_5.
        |: somomo
        [1,3,5]
        true.
*/

task1_5 :-
    readString(Str, Length),
    NewLength is Length - 1,
    subString(Str, NewLength, Length, [Char|_]),
    indexesCharacter(Str, Char, Result),
    write(Result).

indexesCharacter(List, X, Result) :-
    indexesCharacter(List, X, 0, [], Result).
indexesCharacter([X|T], X, Index, List, Result) :-
    appendString(List, [Index], NewList),
    NewIndex is Index + 1,
    indexesCharacter(T, X, NewIndex, NewList, Result),!.
indexesCharacter([_|T], X, Index, List, Result) :-
    NewIndex is Index + 1,
    indexesCharacter(T, X, NewIndex, List, Result),!.
indexesCharacter([], _, _, Result, Result) :- !.
