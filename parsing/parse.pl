%%%%%%%%%%%%%%%%%
% Your code here:
%%%%%%%%%%%%%%%%%

parse(X) :- lines(X, []).

% Grammar: Lines -> Line ; Lines | Line
lines(In, Out) :-
    line(In, Rem),
    (   match(';', Rem, Rem2)
    ->  lines(Rem2, Out)  % Recursive case: found ';', parse more Lines
    ;   Out = Rem         % Base case: just a Line
    ).

% Grammar: Line -> Num , Line | Num
line(In, Out) :-
    num(In, Rem),
    (   match(',', Rem, Rem2)
    ->  line(Rem2, Out)   % Recursive case: found ',', parse more Line
    ;   Out = Rem         % Base case: just a Num
    ).

% Grammar: Num -> Digit Num | Digit
num(In, Out) :-
    digit(In, Rem),
    num(Rem, Out).
num(In, Out) :-
    digit(In, Out).

% Grammar: Digit -> 0 | 1 ... | 9
digit([H|T], T) :-
    my_member(H, ['0','1','2','3','4','5','6','7','8','9']).

match(H, [H|T], T).

my_member(X, [X|_]).
my_member(X, [_|T]) :- my_member(X, T).