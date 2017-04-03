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
    return grid[pos.y * ((int)NumCellsX) * pos.x]
proc setCellValue*(pos: Vector2, value: uint8) =
    grid[pos.y * ((int)NumCellsX) + pos.x] = value