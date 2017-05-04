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
import background

type
    TileBlock = array[256, Tile]
    
type OtherTile* = array[64, uint8]
var memBGPalette* = (cast[ptr array[16, uint16]]((0x05000000)))
var memTile* = (cast[ptr array[3, TileBlock]]((0x6000000)))
var memScreenBlocks* = (cast[ptr array[2, ScreenBlock]]((0x6000000)))

proc makeColor (red, green, blue: uint): uint {.inline.} =
    return red or (green shl 5) or (blue shl 10)

proc generateGradient() =
    
    # we've uploaded 4 colours to palette memory
    # so make sure we don't overwrite those
    for i in 0'u..31'u:
       memBGPalette[4'u+i] = (uint16)makeColor(i, i, i)

    # every tile is 64 palette indices
    # we have 32 grayscale values from above
    var tile: Tile
    var x = 0
    for i in 0'u8..63'u8:
        for j in 0'u8..63'u8:
            tile[j] = 4'u8 + i
        memTile[1][i] = tile
    # generate 2 screen blocks,
    # each gray value getting two tiles of width
    for blck in 0'u16..1'u16:
        var screenBlock: ScreenBlock
        # screen block data is row by row, top to bottom
        for i in 0'u16..31'u16:
            for j in 0'u16..31'u16:
                # each block gets 16 colours, 2 tiles wide for each
                screenBlock[i * 32 + j] = (j div 2'u16) + (blck * 16'u16)
        memScreenBlocks[blck+2] = screenBlock

proc main () =
    for i in 0..<bgPal.len:
        memBGPalette[i] = bgPal[i]
    memScreenBlocks[1] = checkerBg
    memTile[0][1] = bgTiles
    generateGradient()
    var hScroll = 0
    var h2Scroll = 0
    regBG0Control[] = 0b0000_0001_1000_0000 # 0x0180
    regBG1Control[] = 0b0100_0010_1000_0101 # 0x4285
    regDisplayControl[] = VideoMode0 or BGMode0 or BGMode1
    while true:
        vsync()
        regBG0ScrollH[] = (uint16)(-hScroll)
        regBG1ScrollH[] = (uint16)h2Scroll
        h2Scroll += 2
        hScroll = h2Scroll div 3

when isMainModule:
    main()