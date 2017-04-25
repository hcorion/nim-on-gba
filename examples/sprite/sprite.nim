type Tile* = array[64, uint32]
let spriteTiles* {.codegenDecl: "$# $# __attribute__((aligned(4)))".} : Tile =
    [(uint32)0x00000000,0x01000000,0x00000000,0x01010000,0x00000000,0x01010100,0x00000000,0x01010101,
    0x01000000,0x01010101,0x01010000,0x01010101,0x01010100,0x01010101,0x01010101,0x01010101,
    0x00000003,0x00000000,0x00000303,0x00000000,0x00030303,0x00000000,0x03030303,0x00000000,
    0x03030303,0x00000003,0x03030303,0x00000303,0x03030303,0x00030303,0x03030303,0x03030303,
    0x04040404,0x04040404,0x04040400,0x04040404,0x04040000,0x04040404,0x04000000,0x04040404,
    0x00000000,0x04040404,0x00000000,0x04040400,0x00000000,0x04040000,0x00000000,0x04000000,
    0x02020202,0x02020202,0x02020202,0x00020202,0x02020202,0x00000202,0x02020202,0x00000002,
    0x02020202,0x00000000,0x00020202,0x00000000,0x00000202,0x00000000,0x00000002,0x00000000]

let spritePal* {.codegenDecl: "$# $# __attribute__((aligned(4)))".} : array[4, uint16] =
    [(uint16)0x001E,0x7FFF,0x03E0,0x7C1F]