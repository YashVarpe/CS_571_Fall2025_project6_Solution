%%%%%%%%%%%%%%%%%
% Your code here:
%%%%%%%%%%%%%%%%%

% Main entry point
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
% We prioritize the recursive case (Digit Num) to greedily match multiple digits.
num(In, Out) :-
    digit(In, Rem),
    num(Rem, Out).
num(In, Out) :-
    digit(In, Out).

% Grammar: Digit -> 0 | 1 ... | 9
digit([H|T], T) :-
    member(H, ['0','1','2','3','4','5','6','7','8','9']).

% Helper to match a specific token
match(H, [H|T], T).

% Example execution provided in comments for verification:
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2']).
% true.
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2', ',']).
% false.
% ?- parse(['3', '2', ',', ';', '0']).
% false.