writeList([]):- writeln(""), !.
writeList([Head|Tail]):-
    write(Head), write(" "),
    writeList(Tail).

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



