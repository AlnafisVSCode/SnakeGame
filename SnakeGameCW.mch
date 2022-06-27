/* SnakeGameCW
 * Author: w1727389
 * Creation date: 09/01/2022
 */
MACHINE
    SnakeGameCW
    
SETS
    REPORT = {Nomal_Move, MoveHasFailed, Snake_Encountered, Ladder_Encountered, TurnsTaken, NewGame, Current_Position, WentDownASnake, ThrewTooHigh, Finished_and_GameWon, GoUpALadder}
    
CONSTANTS
    board,
    ladder,
    snakeHead,
    diceSet
    
PROPERTIES 
    
    ladder = {(3|->39),(10|->12),(27|->53),(56|->84),(61|->99),(72|->90)}
    
    &
    
    snakeHead = {(31|->4),(47|->25),(16|->13),(66|->52),(63|->60),(97|->75)}
    
    &
    
    diceSet <: NAT & diceSet = 1..6 
    
    &
    
    board <: NAT & board = 1..100
    
VARIABLES
    
    currentPosition, previous_Positions, snakes_Encountered, laddersEncountered, squaresVisited, numOfTurnsTaken
    
INVARIANT
    
    squaresVisited <: NAT1
    &
    numOfTurnsTaken : NAT
    &
    currentPosition : NAT1 
    &
    previous_Positions : NAT1 
    &
    snakes_Encountered : NAT 
    &
    laddersEncountered : NAT
    
    
INITIALISATION
    
    currentPosition, previous_Positions, snakes_Encountered, laddersEncountered, numOfTurnsTaken, squaresVisited := 1, 1, 0, 0, 0, {}
    
OPERATIONS
    
    squareOccupied, report <-- roll( dice ) = 
    
    PRE
        dice : diceSet
    THEN
        
        IF (currentPosition + dice : dom(snakeHead))
            
        THEN 
            previous_Positions := currentPosition + dice
            ||
            currentPosition := snakeHead(currentPosition + dice)
            ||
            squaresVisited := squaresVisited \/ {previous_Positions, currentPosition} 
            ||
            snakes_Encountered := snakes_Encountered + 1
            ||
            numOfTurnsTaken := numOfTurnsTaken + 1
            || 
            squareOccupied := snakeHead(currentPosition + dice)
            || 
            report := WentDownASnake
             
            
        ELSIF (currentPosition + dice : dom(ladder))
        THEN
            previous_Positions := currentPosition + dice 
            ||
            currentPosition := ladder(currentPosition + dice)
            ||
            squaresVisited := squaresVisited \/ {previous_Positions, currentPosition}
            ||
            numOfTurnsTaken := numOfTurnsTaken + 1
            ||
            squareOccupied := ladder(currentPosition + dice)
            || 
            report := GoUpALadder  
            || 
            laddersEncountered := laddersEncountered + 1
            
        ELSIF (currentPosition + dice <  100)
            
        THEN 
            previous_Positions := currentPosition 
            ||
            currentPosition := currentPosition + dice
            ||
            squaresVisited := squaresVisited \/ {previous_Positions, currentPosition } 
            ||
            numOfTurnsTaken := numOfTurnsTaken + 1
            ||
            squareOccupied := currentPosition + dice
            ||
            report := Nomal_Move
            
        ELSIF (currentPosition + dice = 100)
        THEN
            
            report := Finished_and_GameWon
            ||
            previous_Positions := currentPosition 
            ||
            currentPosition := currentPosition + dice
            ||
            squaresVisited := squaresVisited \/ {previous_Positions, currentPosition } 
            ||
            numOfTurnsTaken := numOfTurnsTaken + 1
            ||
            squareOccupied := currentPosition + dice
            
            
        ELSIF (currentPosition + dice > 100)
        THEN
            squareOccupied := currentPosition + dice
            ||
            report := ThrewTooHigh
        ELSE 
            report := MoveHasFailed
        END
        
    END;
    
    report <-- PlayNewGame = 
    BEGIN
        currentPosition, previous_Positions, snakes_Encountered, laddersEncountered, numOfTurnsTaken, squaresVisited, report := currentPosition / currentPosition, previous_Positions / previous_Positions, 0, 0, 0, {}, NewGame 
    END;
    
    currentPositionOnBoard <-- CurrentPosition = 
    BEGIN
        currentPositionOnBoard := currentPosition
    END;
    
    previousPositionOnBoard <-- LastPosition = 
    BEGIN
        previousPositionOnBoard := previous_Positions
    END;
    
    snakesEncounteredCount <-- SnakesEncountered = 
    BEGIN
        snakesEncounteredCount := snakes_Encountered 
    END;
    
    laddersEncounteredCount <-- LaddersEncountered = 
    BEGIN
        laddersEncounteredCount := laddersEncountered 
    END;
    
    numberOfTurnsTakenCount <-- NumTurnsTaken =
    BEGIN
        numberOfTurnsTakenCount := numOfTurnsTaken 
    END;
    
    numberOfSquaresVisited <-- VisitedSquares = 
    BEGIN
        numberOfSquaresVisited := squaresVisited
    END;
    
    reportCurrent, CurrentPosition, reportSnakes, SnakesEncountered, reportLadders, LaddersEncountered, reportTurns, NumOfTurnsTaken  <-- GStat = 
    BEGIN
        reportCurrent, CurrentPosition, reportSnakes, SnakesEncountered, reportLadders, LaddersEncountered, reportTurns, NumOfTurnsTaken :=  Current_Position, currentPosition, Snake_Encountered, snakes_Encountered,Ladder_Encountered, laddersEncountered, TurnsTaken, numOfTurnsTaken
    END
    
END