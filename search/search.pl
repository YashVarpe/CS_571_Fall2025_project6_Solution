%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here:
%%%%%%%%%%%%%%%%%%%%%%

search(Actions) :-
    initial(StartRoom),
    % BFS Queue Item: [state(Room, Keys), Path]
    % Initial State: Room=StartRoom, Keys=[], Path=[]
    % Visited List: [state(Room, Keys)]
    bfs([[state(StartRoom, []), []]], [state(StartRoom, [])], Actions).

% Base Case: If the first state in the queue is the treasure room, we are done.
bfs([[state(Room, _), Path]|_], _, Path) :-
    treasure(Room).

% Recursive Step: Expand the current node
bfs([ [state(Room, Keys), Path] | RestQueue], Visited, Actions) :-
    findall(
        [state(NextRoom, NewKeys), NewPath],
        (
            % 1. Find a connected room (graph is undirected)
            (door(Room, NextRoom); door(NextRoom, Room)),
            
            % 2. Check if the door is passable (not locked, or have key)
            ( (locked_door(Room, NextRoom, Color); locked_door(NextRoom, Room, Color)) ->
                member(Color, Keys)
            ;
                true
            ),
            
            % 3. Update keys if the new room has a key
            (key(NextRoom, KeyColor) ->
                sort([KeyColor | Keys], NewKeys) % sort handles uniqueness
            ;
                NewKeys = Keys
            ),
            
            % 4. Ensure this specific state (Room + Keys) hasn't been visited
            \+ member(state(NextRoom, NewKeys), Visited),
            
            % 5. Append move to the path
            append(Path, [move(Room, NextRoom)], NewPath)
        ),
        Children
    ),
    
    % Update Visited list with new states to prevent cycles/redundancy
    extract_states(Children, ChildStates),
    append(Visited, ChildStates, NewVisited),
    
    % Add new paths to the end of the queue (BFS behavior)
    append(RestQueue, Children, NewQueue),
    
    % Continue search
    bfs(NewQueue, NewVisited, Actions).

% Helper to extract just the state objects from the queue items for the Visited list
extract_states([], []).
extract_states([[State, _]|T], [State|Rest]) :-
    extract_states(T, Rest).