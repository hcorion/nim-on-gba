import ../../gba

const
    NumCellsX*: uint = 22
    NumCellsY*: uint = 14
    CellSize*: uint = 10
    FrameSize*: uint = 2
    PaddingSize*: uint = 8
    GridStart*: uint = FrameSize + PaddingSize
type
    Vector2* = tuple
        x, y: int
    GameState* = enum
        Playing, 
        Won, 
        Lost

var grid*: array[((int)NumCellsX) * (int)NumCellsY, uint8]

proc getCellValue*(pos: Vector2): uint8 =
    ## This gets returns the value of `pos.x` and `pos.y` from the grid.
    ## If the position is greater than the size of the grid, it return 1.
    ## If the position is negative, than it returns 1.
    ## That is a dirty hack to avoid errors.
    var finalPos = pos.y * ((int)NumCellsX) + pos.x
    if finalPos >= ((int)NumCellsX*NumCellsY):
        return 1
    elif finalPos < 0:
        return 1
    else:
        return grid[finalPos]
proc setCellValue*(pos: Vector2, value: uint8) =
    var finalPos = pos.y * ((int)NumCellsX) + pos.x
    grid[finalPos] = value