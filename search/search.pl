search(Actions) :-
    initial(StartRoom),
    % Initial state: StartRoom with keys found in that room
    get_keys(StartRoom, [], InitialKeys),
    % BFS Queue: List of [CurrentRoom, CurrentKeys, PathSoFar]
    % Visited: List of visited(Room, Keys) to prevent cycles
    bfs([[StartRoom, InitialKeys, []]], [visited(StartRoom, InitialKeys)], Actions).

% Base Case
bfs([[Room, _Keys, Path] | _], _, Actions) :-
    treasure(Room),
    my_reverse(Path, Actions).

% Recursive Step
bfs([[Room, Keys, Path] | RestQueue], Visited, Actions) :-
    findall(
        [NextRoom, NextKeys, [move(Room, NextRoom) | Path]],
        (
            can_move(Room, NextRoom, Keys),
            get_keys(NextRoom, Keys, NextKeys),
            \+ my_member(visited(NextRoom, NextKeys), Visited)
        ),
        NewStates
    ),
    extract_visited(NewStates, NewVisited),
    my_append(Visited, NewVisited, UpdatedVisited),
    my_append(RestQueue, NewStates, NewQueue),
    bfs(NewQueue, UpdatedVisited, Actions).


can_move(A, B, _) :- door(A, B).
can_move(A, B, _) :- door(B, A).
can_move(A, B, Keys) :- locked_door(A, B, Color), my_member(Color, Keys).
can_move(A, B, Keys) :- locked_door(B, A, Color), my_member(Color, Keys).

get_keys(Room, CurrentKeys, SortedKeys) :-
    findall(K, key(Room, K), RoomKeys),
    my_append(CurrentKeys, RoomKeys, AllKeys),
    sort(AllKeys, SortedKeys). % sort is standard ISO Prolog, usually safe

extract_visited([], []).
extract_visited([[R, K, _] | T], [visited(R, K) | VT]) :-
    extract_visited(T, VT).
