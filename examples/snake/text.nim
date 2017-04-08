import ../../gba
const fontTiles: array[96, int64] = [
    (int64)0x0000000000000000, 0x0018001818181818, 0x0000000000003636, 0x0036367F367F3636,
    0x00183E603C067C18, 0x0033566C1B356600, 0x00DE733B6E16361C, 0x00000000000C1818,
    0x0030180C0C0C1830, 0x000C18303030180C, 0x0000663CFF3C6600, 0x000018187E181800,
    0x0C18180000000000, 0x000000007E000000, 0x0018180000000000, 0x0003060C183060C0,
    0x003C666E7E76663C, 0x00181818181E1C18, 0x007E0C183060663C, 0x003C66603860663C,
    0x0030307F33363C38, 0x003C6660603E067E, 0x003C66663E060C38, 0x001818183060607E,
    0x003C66663C66663C, 0x001C30607C66663C, 0x0018180000181800, 0x0C18180000181800,
    0x0000601806186000, 0x0000007E007E0000, 0x0000061860180600, 0x001800183060663C,

    0x003C067A5A5A663C, 0x006666667E66663C, 0x003E66663E66663E, 0x00780C0606060C78,
    0x001E36666666361E, 0x007E06061E06067E, 0x000606061E06067E, 0x007C66667606663C,
    0x006666667E666666, 0x003C18181818183C, 0x003C666060606060, 0x0063331B0F1B3363,
    0x007E060606060606, 0x006363636B7F7763, 0x006363737B6F6763, 0x003C66666666663C,
    0x000606063E66663E, 0x007E3B333333331E, 0x006666363E66663E, 0x003C66703C0E663C,
    0x001818181818187E, 0x003C666666666666, 0x00183C3C66666666, 0x0063777F6B636363,
    0x00C3663C183C66C3, 0x00181818183C66C3, 0x007F03060C18307F, 0x003C0C0C0C0C0C3C,
    0x00C06030180C0603, 0x003C30303030303C, 0x0000000000663C18, 0x003F000000000000,

    0x0000000000301818, 0x007C667C603C0000, 0x003E6666663E0606, 0x003C0606063C0000,
    0x007C6666667C6060, 0x003C067E663C0000, 0x000C0C0C0C3E0C38, 0x3C607C66667C0000,
    0x00666666663E0606, 0x0030181818180018, 0x1E30303030300030, 0x0066361E36660606,
    0x0030181818181818, 0x0063636B7F370000, 0x00666666663E0000, 0x003C6666663C0000,
    0x06063E66663E0000, 0x60607C66667C0000, 0x00060606663E0000, 0x003E603C063C0000,
    0x00380C0C0C3E0C0C, 0x007C666666660000, 0x00183C6666660000, 0x00367F6B63630000,
    0x0063361C36630000, 0x0C183C6666660000, 0x007E0C18307E0000, 0x003018180C181830,
    0x0018181818181818, 0x000C18183018180C, 0x00000000003B6E00, 0x0000000000000000
]

proc drawString*(msg: cstring, color: uint16, x1, y: int) =
    ## This is based on the algorithm here: 
    ## https://www.coranac.com/tonc/text/text.htm
    ## This procedure needs to be rock-solid stable 
    ## because it's used in panicoverride.
    var x = x1
    var pos = y * ((int)ScreenWidth) + x
    const CharOffset = 32 # characters 0-32 have no displayable output.
    for c in msg:
        if c == '\x0A':
            pos.inc(((int)ScreenWidth * 8))
            x = 0
        elif ((int)c) >= CharOffset:

            let index = (((int)c) - CharOffset)

            # Each row is one byte
            var glyphBytes = cast[ array[8, uint8]](fontTiles[index])

            var row: uint32
            for iy in 0..7:
                row = glyphBytes[iy]
                var ix = x
                while row > 0'u32:
                    if (row and 1) > 0:
                        var screenPos = pos + ((y + iy) * ((int)ScreenWidth) + (x+ix))
                        if screenPos < (int)ScreenWidth*ScreenHeight:
                            screenBuffer[screenPos] = color
                    row = row shr 1
                    ix.inc(1)
        x.inc(4) # 4 = width of glyph in nibbles
proc drawString*(num: int, color: uint16, x, y: int) =
    var t: cstring = " "
    t[0] = (char)num+48
    drawString(t, color, x, y)