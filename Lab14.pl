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

valueByIndex([H|T], Index, Result) :-
    valueByIndex([H|T], 0, Index, Result),!.
    
valueByIndex([Result|_], Index, Index, Result).

valueByIndex([_|T], CurIndex, Index, Result) :-
    NewCurIndex is CurIndex + 1,
    valueByIndex(T, NewCurIndex, Index, Result).

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

subString([H|T], Start, End, Result) :-
    subString([H|T], Start, End, 0, [], Result).

subString([H|T], Start, End, I, List, Result) :-
    I >= Start, I < End,
    appendString(List, [H], NewList),
    NewI is I + 1,
    subString(T, Start, End, NewI, NewList, Result),!.

subString([_|T], Start, End, I, List, Result) :-
    NewI is I + 1,
    subString(T, Start, End, NewI, List, Result),!.

subString([], _, _, _, Result, Result) :- !.

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



% --------- 2.1 ---------

% Дан файл. Прочитать из файла строки и вывести длину наибольшей строки.

task2_1 :-
    see('/Users/snowlukin/Desktop/PrologLabs/2_1.txt'),
    readStringList(StringsList), seen,
    maxLengthList(StringsList, MaxLen),
    write(MaxLen),!.

count([X|T], Result) :-
    count([X|T], 0, Result).
count([_|T], Count, Result) :-
    NewCount is Count + 1,
    count(T, NewCount, Result), !.
count([], Result, Result) :- !.

readStringList(List) :-
    readString(A,_,Flag),
    readStringList([A],List,Flag).
readStringList(List,List,1) :- !.
readStringList(Cur_list,List,0) :-
    readString(A,_,Flag),
    (not(A = []), appendString(Cur_list,[A],C_l),
    readStringList(C_l,List,Flag);
    readStringList(Cur_list,List,Flag)),!.

maxLengthList(List, Result) :-
    maxLengthList(List, 0, Result).
maxLengthList([H|T], CurMax, Result) :-
    count(H, NewMax),
    NewMax > CurMax,
    maxLengthList(T, NewMax, Result), !.
maxLengthList([_|T], CurMax, Result) :-
    maxLengthList(T, CurMax, Result), !.
maxLengthList([], Result, Result) :- !.


% --------- 2.2 ---------

% Дан файл. Определить, сколько в файле строк, не содержащих пробелы.

task2_2 :-
    see('/Users/snowlukin/Desktop/PrologLabs/2_2.txt'),
    readStringList(StringsList),
    seen,
    countNoSpacesStrings(StringsList, Count),
    write(Count),!.

countCharacter(Str, Char, Result) :-
    char_code(Char, CharCode),
    countCharacter(Str, CharCode, 0, Result).
countCharacter([S|T], Char, Count, Result) :-
    S = Char,
    NewCount is Count + 1,
    countCharacter(T, Char, NewCount, Result),!.
countCharacter([_|T], Char, Count, Result) :-
    countCharacter(T, Char, Count, Result), !.
countCharacter([], _, Result, Result) :- !.

countNoSpacesStrings(StringsList, Result) :-
    countNoSpacesStrings(StringsList, 0, Result),!.
countNoSpacesStrings([H|T], Count, Result) :-
    countCharacter(H, " ", SpaceCount),
    SpaceCount is 0,
    NewCount is Count + 1,
    countNoSpacesStrings(T, NewCount, Result),!.
countNoSpacesStrings([_|T], Count, Result) :-
    countNoSpacesStrings(T, Count, Result),!.
countNoSpacesStrings([], Result, Result) :- !.


% --------- 2.3 ---------

% Дан файл, найти и вывести на экран только те строки, в которых букв
% А больше, чем в среднем на строку.

task2_3 :-
    see('/Users/snowlukin/Desktop/PrologLabs/2_3.txt'),
    readStringList(StringsList),
    seen,
    count(StringsList, Len),
    countCharacterList(StringsList, "a", Count1),
    countCharacterList(StringsList, "A", Count2),
    Count is Count1 + Count2,
    Avg is Count / Len,
    writeStringMoreA(StringsList, Avg).

countCharacterList(List, Char, Result) :-
    countCharacterList(List, Char, 0, Result),!.
countCharacterList([H|T], Char, Count, Result) :-
    countCharacter(H, Char, Count1),
    NewCount is Count + Count1,
    countCharacterList(T, Char, NewCount, Result),!.
countCharacterList([], _, Result, Result) :- !.

writeStringMoreA([H|T], Avg) :-
    countCharacter(H, "a", Count1),
    countCharacter(H, "A", Count2),
    Count is Count1 + Count2,
    Count > Avg,
    writeString(H), nl,
    writeStringMoreA(T, Avg),!.
writeStringMoreA([_|T], Avg) :- writeStringMoreA(T, Avg), !.
writeStringMoreA([], _) :- !.


% --------- 2.4 ---------

% Дан файл, вывести самое частое слово.

task2_4 :-
    see('/Users/snowlukin/Desktop/PrologLabs/2_4.txt'),
    readStringList(StringList),
    seen,
    stringsListToString(StringList, BigString),
    mostCommonWordList(BigString, Word),
    writeString(Word).

mostCommonWordList(Words, Result) :-
    mostCommonWord(Words, Words, 0, [], Result).

stringsListToString(StrList, Result) :-
    stringsListToString(StrList, [], Result).
stringsListToString([H|T], List, Result) :-
    splitString(H, " ", StrWords),
    appendString(List, StrWords, NewList),
    stringsListToString(T, NewList, Result), !.
stringsListToString([], Result, Result) :- !.


% --------- 2.5 ---------

% Дан файл, вывести в отдельный файл строки, состоящие из слов, не
% повторяющихся в исходном файле.

task2_5 :-
    see('/Users/snowlukin/Desktop/PrologLabs/2_5_READ.txt'),
    readStringList(StrList),
    seen,
    stringsListToString(StrList, Words),
    repeatingWords(Words, RepWords),
    tell('/Users/snowlukin/Desktop/PrologLabs/2_5_WRITE.txt'),
    writeNoRepeatingWordsStrings(StrList, RepWords),
    told.

inList([X|_], X).
inList([_|T] ,X) :- inList(T, X).

containsList(List, [H|_]) :- inList(List, H), !.
containsList(List, [_|T]) :- containsList(List, T).

repeatingWords(Words, Result) :-
    repeatingWords(Words, [], [], Result).
repeatingWords([H|T], List, RepList, Result) :-
    inList(List, H),
    appendString(List, [H], NewList),
    appendString(RepList, [H], NewRepList),
    repeatingWords(T, NewList, NewRepList, Result),!.
repeatingWords([H|T], List, RepList, Result) :-
    appendString(List, [H], NewList),
    repeatingWords(T, NewList, RepList, Result),!.
repeatingWords([], _, Result, Result) :- !.

writeNoRepeatingWordsStrings([H|T], RepWords) :-
    splitString(H, " ", Words),
    not(containsList(Words, RepWords)),
    writeString(H), nl,
    writeNoRepeatingWordsStrings(T, RepWords), !.
writeNoRepeatingWordsStrings([_|T], RepWords) :-
    writeNoRepeatingWordsStrings(T, RepWords), !.
writeNoRepeatingWordsStrings([], _) :- !.


% --------- 3.2 ---------

% Дана строка, состоящая из символов латиницы. Необходимо проверить,
% упорядочены ли строчные символы этой строки по возрастанию.

/*
    Example:
        ?- task3_2.
        |: abcdef
        Sorted
        true.

        ?- task3_2.
        |: something
        Not Sorted
        true.
*/

task3_2 :-
    readString(String, _),
    string_to_list(String, List),
    isSortedUp(List).

isSortedUp([H|T]) :- isSortedUp(T, H), !.
isSortedUp([], _) :- writeln("Sorted").
isSortedUp([H|T], Previous) :-
    H > Previous,
    isSortedUp(T, H);
    writeln("Not Sorted").


% --------- 3.10 ---------

% Дана строка. Необходимо подсчитать количество букв "А" в этой
% строке.

/*
    Example:
        ?- task3_10.
        |: sbabsA
        2
        true.
*/

isA(Char) :- 97 is Char; 65 is Char, !.

task3_10 :-
    readString(String, _),
    string_to_list(String, List),
    include(isA, List, NewList),
    length(NewList, Length),
    writeln(Length), !.


% --------- 3.17 ---------

% Дана строка в которой записан путь к файлу. Необходимо найти имя
% файла без расширения.

% "/" - 47
% "." - 46
% "/Users/snowlukin/Desktop/PrologLabs/file_name.txt"

task3_17 :-
    % readString(String, _),
    String = "/Users/snowlukin/Desktop/PrologLabs/file_name.txt",
    atom_chars(String, CharList),
    atom_codes(String, CodeList),
    reverse(CodeList, ReversedCodeList),
    nth0(SlashIndex, ReversedCodeList, 47),
    length(CodeList, CodeListLength),
    RealSlashIndex is CodeListLength - SlashIndex,
    split(RealSlashIndex, CharList, _, AfterSlashList),
    atomic_list_concat(AfterSlashList, '', AfterSlashAtom),
    atom_string(AfterSlashAtom, AfterSlashString),
    atom_codes(AfterSlashString, AfterSlashCodeList),
    nth0(DotIndex, AfterSlashCodeList, 46),
    split(DotIndex, AfterSlashList, BeforeDotList, _),
    atomic_list_concat(BeforeDotList, '', BeforeDotAtom),
    atom_string(BeforeDotAtom, BeforeDotString),
    writeln(BeforeDotString), !.
    
split(Index, List, Left, Right) :-
   length(Left,Index),
   append(Left,Right,List), !.
    

% --------- 6 ---------

/*
    Результат записывать в файл.
    Дано множество. Построить все размещения с повторениями по k
    элементов.
    Дано множество. Построить все перестановки.
    Дано множество. Построить все размещения по k элементов.
    Дано множество. Построить все подмножества.
    Дано множество. Построить все сочетания по k элементов.
    Дано множество. Построить все сочетания с повторениями.
*/

/*
    Example:
        ?- task6.
        |: 5.
        |: a.
        |: b.
        |: c.
        |: d.
        |: e.
        |: 3.

        true.
*/

task6 :-
    read(N),
    readList(N, List),
    read(K),
    tell('/Users/snowlukin/Desktop/PrologLabs/6.txt'),
    write(List), nl, write(" K = "), write(K), nl, nl, nl, nl,
    write("Размещения с повторениями из N по K: "), nl, nl,
    aRepWrite(List, K), nl, nl, nl,
    write("Перестановки из N: "), nl, nl,
    pWrite(List), nl, nl, nl,
    write("Размещения из N по K: "), nl, nl,
    aWrite(List, K), nl, nl, nl,
    write("Подмножества: "), nl, nl,
    subSetWrite(List), nl, nl, nl,
    write("Сочетания из N по K: "), nl, nl,
    cWrite(List, K), nl, nl, nl,
    write("Сочетания с повторениями из N по K: "), nl, nl,
    cRepWrite(List, K), nl, nl, nl,
    told.

readList(0, []) :- !.
readList(I, [X|T]) :- read(X), I1 is I - 1, readList(I1, T).

% 6.1 - Размещения из N по K с повторениями

aRepWrite(List, K) :-
    not(aRepWriteInternal(List, K)).
aRepWriteInternal(List, K) :-
    aRep(List, K, A),
    write(A), nl, fail.
aRep(List, K, Ans) :-
    aRep(List, K, [], Ans).
aRep(List, K, CurList, Ans) :-
    K > 0,
    inList(List, X),
    NewK is K - 1,
    aRep(List, NewK, [X|CurList], Ans).
aRep(_, 0, Ans, Ans) :- !.



% 6.2 Перестановки из N

pWrite(List) :-
    count(List, K),
    aWrite(List, K).
p(List, Ans) :-
    count(List, K),
    a(List, K, Ans).


% 6.3 Размещения из N по K

inListNoRep([H|T],H,T).
inListNoRep([H|T],Elem,[H|Tail]):-inListNoRep(T,Elem,Tail).

aWrite(List, K) :-
    not(aWriteInternal(List, K)).
aWriteInternal(List, K) :-
    a(List, K, A),
    write(A), nl, fail.

a(List, K, Ans) :-
    a(List, K, [], Ans).
a(List, K, CurPerm, Ans) :-
    K > 0,
    inListNoRep(List, X, NewList),
    NewK is K - 1,
    a(NewList, NewK, [X|CurPerm], Ans).
a(_, 0, Ans, Ans) :- !.


% 6.4 Подмножества

subSetWrite(List) :-
    not(subSetWriteInternal(List)).
subSetWriteInternal(List) :-
    subSet(List, SubSet),
    write(SubSet), nl, fail.

subSet([Elem|SetTail], [Elem|SubSetTail]) :-
    subSet(SetTail, SubSetTail).
subSet([_|SetTail], SubSet) :-
    subSet(SetTail, SubSet).
subSet([], []).

% 6.5 Сочетания из N по K

cWrite(List, K) :-
    not(cWriteInternal(List, K)).
cWriteInternal(List, K) :-
    c(List, K, C),
    write(C), nl, fail.

c(_, 0, []) :- !.
c([Elem|SetTail], K, [Elem|SubSetTail]) :-
    NewK is K-1,
    c(SetTail, NewK, SubSetTail).
c([_|SetTail], K, SubSet) :-
    c(SetTail, K, SubSet).



% 6.6 Сочетания с повторениями из N по K

cRepWrite(List, K) :-
    not(cRepWriteInternal(List, K)).
cRepWriteInternal(List, K) :-
    cRep(List, K, C),
    write(C), nl, fail.

cRep(_, 0, []) :- !.
cRep([Elem|SetTail], K, [Elem|SubSetTail]) :-
    NewK is K-1,
    cRep([Elem|SetTail], NewK, SubSetTail).
cRep([_|SetTail], K, SubSet) :-
    cRep(SetTail, K, SubSet).



% --------- 7 ---------

% Дано множество {a,b,c,d,e,f}. Построить все слова длины 5, в
% которых ровно две буквы a. Вывод в файл.

task7 :-
    tell('/Users/snowlukin/Desktop/PrologLabs/7.txt'),
    not(task7Sub),
    told.

task7Sub :-

    Positions = [0, 1, 2, 3, 4],
    Word = [_, _, _, _, _],
    
    % Pos1, Pod2 будут всевозможными индексами на которые будем ставить символ "a"
    c(Positions, 2, [PosA1, PosA2]),
    
    valueByIndex(Word, PosA1, a),
    valueByIndex(Word, PosA2, a),
    
    % Индексы свободных позиций
    inListNoRep(Positions, PosA1, PositionsNoA),
    inListNoRep(PositionsNoA, PosA2, [Pos1, Pos2, Pos3]),

    aRep([b,c,d,e,f], 3, [Char1, Char2, Char3]),

    valueByIndex(Word, Pos1, Char1),
    valueByIndex(Word, Pos2, Char2),
    valueByIndex(Word, Pos3, Char3),

    write(Word), nl, fail.


% --------- 8 ---------

% Дано множество {a,b,c,d,e,f}. Построить все слова длины 5, в
% которых ровно 2 буквы a, остальные буквы не повторяются. Вывод в файл.

task8 :-
    tell('/Users/snowlukin/Desktop/PrologLabs/8.txt'),
    not(task8Sub),
    told.

task8Sub :-

    Positions = [0, 1, 2, 3, 4],
    Word = [_, _, _, _, _],

    c(Positions, 2, [PosA1, PosA2]),

    valueByIndex(Word, PosA1, a),
    valueByIndex(Word, PosA2, a),

    inListNoRep(Positions, PosA1, PositionsNoA),
    inListNoRep(PositionsNoA, PosA2, [Pos1, Pos2, Pos3]),

    a([b,c,d,e,f], 3, [Char1, Char2, Char3]),

    valueByIndex(Word, Pos1, Char1),
    valueByIndex(Word, Pos2, Char2),
    valueByIndex(Word, Pos3, Char3),

    write(Word), nl, fail.


% --------- 9 ---------

% Дано множество {a,b,c,d,e,f}. Построить все слова длины 5, в
% которых ровно одна буква повторяется 2 раза, остальные буквы не
% повторяются. Вывод в файл.


task9 :-
    tell('/Users/snowlukin/Desktop/PrologLabs/9.txt'),
    not(task9Sub),
    told.

task9Sub :-
    
    Positions = [0, 1, 2, 3, 4],
    Word = [_, _, _, _, _],
    
    c(Positions, 2, [PosRep2Char1, PosRep2Char2]),
    
    Alphabet = [a,b,c,d,e,f],
    c(Alphabet, 1, [Rep2Char]),
    
    valueByIndex(Word, PosRep2Char1, Rep2Char),
    valueByIndex(Word, PosRep2Char2, Rep2Char),
    
    inListNoRep(Positions, PosRep2Char1, PositionsNoRep2Char),
    inListNoRep(PositionsNoRep2Char, PosRep2Char2, [Pos1, Pos2, Pos3]),
    inListNoRep(Alphabet, Rep2Char, AlphabetNoRep2Char),
    
    a(AlphabetNoRep2Char, 3, [Char1, Char2, Char3]),
    
    valueByIndex(Word, Pos1, Char1),
    valueByIndex(Word, Pos2, Char2),
    valueByIndex(Word, Pos3, Char3),
    
    write(Word), nl, fail.
