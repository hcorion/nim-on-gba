import ../../gba
import game, title, text
import snake as shnake
#import random

var
    score = 0
    snake: Snake
    state: GameState
    targetNode: SnakeNode

proc handleGameInput() =
    if currentKey != previousKey:
        if keyIsDown(KeyRight) > 0'u32:
            updateVelocityX(snake, SnakeRight)
        elif keyIsDown(KeyLeft) > 0'u32:
            updateVelocityX(snake, SnakeLeft)
        if keyIsDown(KeyUp) > 0'u32:
            updateVelocityY(snake, SnakeUp)
        elif keyIsDown(KeyDown) > 0'u32:
            updateVelocityY(snake, SnakeDown)

# Because Nim's random module is rather dependency heavy, 
# we'll just use rand()
proc rand(): cint {.importc: "rand", varargs,
                                  header: "<stdlib.h>".}

proc spawnTargetNode() =
    var t: Vector2 = (-1, -1)
    var lastR = -1
    for y in 0..<NumCellsY:
        for x in 0..<NumCellsX:
            var r = (uint16)rand()
            if grid[y * NumCellsX + x] != 1:
                if t.y == -1 or r > (uint16)lastR:
                    t.y = (int)y
                    t.x = (int)x
                    lastR = (int)r
    targetNode.x = t.x
    targetNode.y = t.y

    drawRect2(
        GridStart + ((uint)t.x) * CellSize, 
        GridStart + ((uint)t.y) * CellSize, 
        CellSize, CellSize, yellow)

proc tickAndDrawGame() =
    if ((uint)snake.head.x) > NumCellsX-1 or 
        ((uint)snake.head.x) < 0 or 
        ((uint)snake.head.y) > NumCellsY-1 or 
        snake.head.y < 0:
        
        state = Lost
        return
    if snake.length == NumCellsY*NumCellsX:
        state = Won
        return
    if snake.head.x == targetNode.x and snake.head.y == targetNode.y:
        addNode(snake)
        addNode(snake)
        spawnTargetNode()
    # clear the tail cell, it's the only part of
    # the grid that needs to clear.
    drawRect2(GridStart + ((uint)snake.tail.x) * CellSize,
              GridStart + ((uint)snake.tail.y) * CellSize,
              CellSize, CellSize, black)
    setCellValue( (snake.tail.x, snake.tail.y), 0)
    if snake.update:
        state = Lost
        return

    drawRect2(GridStart + ((uint)snake.head.x) * CellSize,
              GridStart + ((uint)snake.head.y) * CellSize,
              CellSize, CellSize, white)
    setCellValue( (snake.head.x, snake.head.y), 1)

proc renderGame() = spawnTargetNode()
    
proc restartGame() =
    state = Playing
    #randomize()
    ## TODO: find a cheaper way to clear the grid array
    ## The C code just uses memset
    for i in 0..<grid.len:
        grid[i] = 0
    const
        snakeStart: Vector2 = (((int)NumCellsX) div 2 - 1, (int)NumCellsY div 2 - 1)
    snake.init(snakeStart, NumCellsY * NumCellsX)

    # Clear screen
    drawRect2(0, 0, ScreenWidth, ScreenHeight, black)

    # Redraw frame
    var frameCol: uint16 = lime
    const
        PS = PaddingSize + FrameSize
        FrameRight = ScreenWidth - (uint)PS
        FrameLeft = PaddingSize
        FrameTop = PaddingSize
        FrameHeight = ScreenHeight - PS

    drawRect2(FrameLeft,    FrameTop,    ScreenWidth - PaddingSize * 2, FrameSize,                      frameCol)
    drawRect2(FrameRight,   FrameTop,    FrameSize,                     ScreenHeight - PaddingSize * 2, frameCol)
    drawRect2(FrameLeft,    FrameTop,    FrameSize,                     ScreenHeight - PaddingSize * 2, frameCol)
    drawRect2(FrameLeft,    FrameHeight, ScreenWidth - PaddingSize * 2, FrameSize,                      frameCol)
    
    spawnTargetNode()

var gameOver = false

proc handleGameOverInput() =
    if currentKey != previousKey:
        if keyIsDown(KeyStart) > 0'u32:
            gameOver = true

proc beginGameOverScreen() =
    gameOver = false
    drawRect(0, 0, ScreenWidth, ScreenHeight, red)
    drawString("You Lost", black, 25, 25)
    drawString("Press Start To Retry ", black, 13, 35)

proc main() =
    ## Apparently the compiler can optimize better if the main stuff is in a procedure.

    # Main procedure.
    type MainState = enum
        JustLaunched, 
        Title, 
        Game, 
        End

    var
        appState = JustLaunched
        targetState = Title

    regDisplayControl[] = VideoMode3 or BGMode2 # mode 3 graphics, we aren't actually using bg2 right now
    regIME[] = 1 # enable interrupts
    while true:
        # This is awful, but it works for snake.
        for i in 0..3:
            vsync()
            keyPoll()
            case appState:
                of Title:
                    handleTitleInput()
                of Game:
                    handleGameInput()
                of End:
                    handleGameOverInput()
                else:
                    discard
        if targetState == appState:
            case appState:
                of Title:
                    if not title.titleOn:
                        targetState = Game
                of Game:
                    if state == Won:
                        targetState = End
                    elif state == Lost:
                        targetState = End
                    else:
                        tickAndDrawGame()
                of End:
                    if gameOver == true:
                        targetState = Game
                else:
                    discard
        else:
            appState = targetState
            case appState:
                of Title:
                    beginTitleScreen()
                of Game:
                    restartGame()
                of End:
                    beginGameOverScreen()
                else:
                    discard


when isMainModule:
    main()