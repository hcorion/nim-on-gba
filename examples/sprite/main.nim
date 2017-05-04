import ../../gba
import sprite

type
  ObjectAttributes  = object
    attr0, attr1, attr2: uint16
    pad: uint16
  TileBlock* = array[256, Tile]
var
  memOAM {.volatile codegenDecl: "$# $# __attribute__((packed, aligned(4)))".} = cast[ptr array[3, ObjectAttributes]](0x07000000)
  
  # 6 Tile Blocks
  memTile* = (cast[ptr array[6, TileBlock]](0x06000000))
  
  memPalette* = (cast[ptr array[16, uint16]]((0x05000200)))
proc main() =
    ## Apparently the compiler can optimize better if it's in a main proc.
    
    for i in 0..spritePal.len:
        memPalette[i+1] = spritePal[i]
    # I'm not sure why we have to do this.
    memPalette[5] = 0x0000

    # I don't get what's up with the 16-offset
    for i in 0..<spriteTiles.len:
        memTile[][5][0][i+16] = spriteTiles[i]

    var spriteAttribs {.volatile codegenDecl: "$# $# __attribute__((packed, aligned(4)))".}: ptr ObjectAttributes = addr(memOAM[0])

    spriteAttribs.attr0 = 0x2032 # 8bpp tiles, SQUARE shape, at y coord 50
    spriteAttribs.attr1 = 0x4064 # 16x16 size when using the SQUARE shape
    spriteAttribs.attr2 = 2 # Start at the first tile in tile

    regDisplayControl[] = VideoMode0 or BGModeObj or MappingMode1D
    var x: uint16 = 0
    while true:
        vsync()
        x = (x+1) mod (uint16)ScreenWidth
        spriteAttribs.attr1 = 0x4000'u16 or (0x1FF'u16 and x)

when isMainModule:
    main()