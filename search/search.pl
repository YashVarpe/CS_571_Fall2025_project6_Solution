%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here:
%%%%%%%%%%%%%%%%%%%%%%

search(Actions) :-
    initial(StartRoom),
    bfs([[state(StartRoom, []), []]], [state(StartRoom, [])], Actions).

bfs([[state(Room, _), Path]|_], _, Path) :-
    treasure(Room).

bfs([ [state(Room, Keys), Path] | RestQueue], Visited, Actions) :-
    findall(
        [state(NextRoom, NewKeys), NewPath],
        (
            (door(Room, NextRoom); door(NextRoom, Room)),
            
            ( (locked_door(Room, NextRoom, Color); locked_door(NextRoom, Room, Color)) ->
                member(Color, Keys) % Must have key if locked
            ;
                true % Door is not locked
            ),
            
            findall(K, key(NextRoom, K), FoundKeys),
            append(FoundKeys, Keys, AllKeys),
            sort(AllKeys, NewKeys), % Sort to keep key list canonical
            
            \+ member(state(NextRoom, NewKeys), Visited),
            
            append(Path, [move(Room, NextRoom)], NewPath)
        ),
        Children
    ),

    extract_states(Children, ChildStates),
    append(Visited, ChildStates, NewVisited),
    append(RestQueue, Children, NewQueue),
    
    bfs(NewQueue, NewVisited, Actions).

extract_states([], []).
extract_states([[State, _]|T], [State|Rest]) :-
    extract_states(T, Rest).