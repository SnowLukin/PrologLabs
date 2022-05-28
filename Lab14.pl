% --------- 1.1 ---------
writeList([]):- writeln(""), !.
writeList([Head|Tail]):-
    write(Head), write(" "),
    writeList(Tail).

task1_1(String):-
    atom_chars(String, CharList),
    writeList(CharList),
    length(CharList, Length),
    write("Lenght: "), writeln(Length).
