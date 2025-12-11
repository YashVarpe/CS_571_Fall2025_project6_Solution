
%%%%%%%%%%%%%%%%%
% Your code here:
%%%%%%%%%%%%%%%%%

parse(X) :- 

% Grammar: Lines -> Line ; Lines | Line
lines(In, Out) :-
    line(In, Rem),
    (   match(';', Rem, Rem2)
    ->  lines(Rem2, Out)  % Recursive: found ';', parse more
    ;   Out = Rem         % Base: finished
    ).

% Grammar: Line -> Num , Line | Num
line(In, Out) :-
    num(In, Rem),
    (   match(',', Rem, Rem2)
    ->  line(Rem2, Out)   % Recursive: found ',', parse more
    ;   Out = Rem         % Base: finished
    ).

% Grammar: Num -> Digit | Digit Num
num(In, Out) :-
    digit(In, Out).
num(In, Out) :-
    digit(In, Rem),
    num(Rem, Out).

% Grammar: Digit -> 0 | 1 ... | 9
digit([H|T], T) :-
    member(H, ['0','1','2','3','4','5','6','7','8','9']).

match(H, [H|T], T).

% Example execution:
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2']).
% true.
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2', ',']).
% false.
% ?- parse(['3', '2', ',', ';', '0']).
% false.
