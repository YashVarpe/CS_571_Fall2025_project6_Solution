:- use_module(library(lists)).

%%%%%%%%%%%%%%%%%
% Your code here:
%%%%%%%%%%%%%%%%%

parse(X) :- lines(X, []).

% Grammar: Lines -> Line ; Lines | Line
lines(In, Out) :-
    line(In, Rem),
    (   match(';', Rem, Rem2)
    ->  lines(Rem2, Out)  % If ';' follows, parse more Lines
    ;   Out = Rem         % Else, we are done with Lines
    ).

% Grammar: Line -> Num , Line | Num
line(In, Out) :-
    num(In, Rem),
    (   match(',', Rem, Rem2)
    ->  line(Rem2, Out)   % If ',' follows, parse more Line
    ;   Out = Rem         % Else, we are done with Line
    ).

% Grammar: Num -> Digit | Digit Num
% Strategy: Greedy match (try to consume more digits first)
num(In, Out) :-
    digit(In, Rem),
    num(Rem, Out).
num(In, Out) :-
    digit(In, Out).

% Grammar: Digit -> 0..9
digit([H|T], T) :-
    member(H, ['0','1','2','3','4','5','6','7','8','9']).

% Helper to consume a specific token
match(H, [H|T], T).