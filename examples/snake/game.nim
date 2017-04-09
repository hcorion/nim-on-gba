# Copyright 2017 Zion Nimchuk
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
# associated documentation files (the "Software"), to deal in the Software without restriction, 
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS 
# OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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