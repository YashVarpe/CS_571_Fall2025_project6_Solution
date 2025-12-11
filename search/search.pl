:- use_module(library(lists)).

%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here:
%%%%%%%%%%%%%%%%%%%%%%

search(Actions) :-
    initial(StartRoom),
    % 1. Collect any keys present in the start room immediately
    findall(K, key(StartRoom, K), StartKeys),
    sort(StartKeys, InitialKeys),
    % 2. Start BFS: Queue = [[State, Path]], Visited = [State]
    % State is defined as state(Room, KeysHeld)
    bfs([[state(StartRoom, InitialKeys), []]], [state(StartRoom, InitialKeys)], Actions).

% Base Case: Found the treasure
bfs([[state(Room, _), Path]|_], _, Path) :-
    treasure(Room),
    !. % Cut to stop searching once the shortest path is found

% Recursive Step: Expand BFS
bfs([ [state(Room, Keys), Path] | RestQueue], Visited, Actions) :-
    findall(
        [state(NextRoom, NewKeys), NewPath],
        (
            % A. Find a reachable room
            (
                % Open door (either direction)
                (door(Room, NextRoom); door(NextRoom, Room))
            ;
                % Locked door (either direction) - requires key
                (locked_door(Room, NextRoom, Color); locked_door(NextRoom, Room, Color)),
                member(Color, Keys)
            ),
            
            % B. Collect keys in the new room
            findall(K, key(NextRoom, K), FoundKeys),
            append(FoundKeys, Keys, UnsortedKeys),
            sort(UnsortedKeys, NewKeys), % Sort to keep state canonical
            
            % C. Ensure state (Room + Keys) is not visited
            \+ member(state(NextRoom, NewKeys), Visited),
            
            % D. Update Path
            append(Path, [move(Room, NextRoom)], NewPath)
        ),
        Children
    ),
    
    % Update Visited list and Queue
    extract_states(Children, ChildStates),
    append(Visited, ChildStates, NewVisited),
    append(RestQueue, Children, NewQueue),
    
    % Continue Search
    bfs(NewQueue, NewVisited, Actions).

% Helper: Extract just the state(...) part from the queue items
extract_states([], []).
extract_states([[State, _]|T], [State|Rest]) :-
    extract_states(T, Rest).