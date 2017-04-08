const
    # Memory Adress locations.
    MemIO = 0x04000000
    MemVRAM = 0x06000000
    RegVCountAddr = 0x04000006
    RegIMEAddr = 0x04000208
    RegIEAddr = 0x04000200
    RegDispStatAddr = 0x04000004
    RegKeyInputAddr = 0x4000130
    # All of the video modes.
    VideoMode0* = 0x0000
    VideoMode1* = 0x0001
    VideoMode2* = 0x0002
    VideoMode3* = 0x0003
    VideoMode4* = 0x0004
    VideoMode5* = 0x0005
    BGMode0* = 0x0100
    BGMode1* = 0x0200
    BGMode2* = 0x0400
    BGMode3* = 0x0800
    BGModeObj* = 0x1000
    # The colors of the rainbow.
    black* = 0x0000
    red* = 0x001F
    lime* = 0x03E0
    yellow* = 0x03FF
    blue* = 0x7C00
    magenta* = 0x7C1F
    cyan* = 0x7FE0
    white* = 0x7FFF
    # Other stuff
    ScreenWidth*: uint = 240
    ScreenHeight*: uint = 160


var
    regDisplayControl* {.volatile.} = cast[ptr uint32](0x04000000)
    screenBuffer* = cast[ptr array[(int)ScreenWidth * ScreenHeight, uint16]](MemVRAM)
    regVCount {.volatile.} = cast[ptr uint16](RegVCountAddr)
    regDispCnt {.volatile.} = cast[ptr uint32](MemIO)
    regIME* {.volatile.} = cast[ptr uint16](RegIMEAddr)
    regIE {.volatile.} = cast[ptr uint16](RegIEAddr)
    regDispStat {.volatile.} = cast[ptr uint16](RegDispStatAddr)
    regKeyInput {.volatile.} = cast[ptr uint32](RegKeyInputAddr)

# Timer stuff
const
    TimerCount = 4
    TimerIRQ = 64
    TimerStart = 128
var
  REG_TM0CNT* {.volatile.}= cast[ptr uint32]((MemIO + 0x00000100))[]
  REG_TM0CNT_L* {.volatile.}= cast[ptr uint16]((MemIO + 0x00000100))[]
  REG_TM0CNT_H* {.volatile.}= cast[ptr uint16]((MemIO + 0x00000102))[]
  REG_TM1CNT* {.volatile.}= cast[ptr uint32]((MemIO + 0x00000104))[]
  REG_TM1CNT_L* {.volatile.}= cast[ptr uint16]((MemIO + 0x00000104))[]
  REG_TM1CNT_H* {.volatile.}= cast[ptr uint16]((MemIO + 0x00000106))[]
  REG_TM2CNT* {.volatile.}= cast[ptr uint32]((MemIO + 0x00000108))[]
  REG_TM2CNT_L* {.volatile.}= cast[ptr uint16]((MemIO + 0x00000108))[]
  REG_TM2CNT_H* {.volatile.}= cast[ptr uint16]((MemIO + 0x0000010A))[]
  REG_TM3CNT* {.volatile.}= cast[ptr uint32]((MemIO + 0x0000010C))[]
  REG_TM3CNT_L* {.volatile.}= cast[ptr uint16]((MemIO + 0x0000010C))[]
  REG_TM3CNT_H* {.volatile.}= cast[ptr uint16]((MemIO + 0x0000010E))[]

# Unused
#proc rgb15 (red, green, blue: int): uint16 {.inline.} =
#    return (uint16) red or (green shl 5) or (blue shl 10)

proc vsync*() {.inline.} =
    while regVCount[] >= 160'u16: discard
    while regVCount[] < 160'u16: discard

proc drawPixel (x, y: uint, color: uint16) {.inline.} =
    screenBuffer[y*ScreenWidth+x] = color

proc drawRect*(left, top, right, bottom: uint, color: uint16) =
    let
        width: uint = right - left
        height: uint = bottom - top # Y increases near bottom in GBA land
    for y in 0..height-1:
        for x in 0..width-1:
            drawPixel(left + x, top + y, color)
proc drawRect2*(left, top, width, height: uint, color: uint16) =
    for y in 0..height-1:
        for x in 0..width-1:
            drawPixel(left + x, top + y, color)
proc clearScreen*() =
    screenBuffer = nil


var
    currentKey*: uint16
    previousKey*: uint16
const
    KeyA* = 0x0001
    KeyB* = 0x0002
    KeySelect* = 0x0004
    KeyStart* = 0x0008
    KeyRight* = 0x0010
    KeyLeft* = 0x0020
    KeyUp* = 0x0040
    KeyDown* = 0x0080
    KeyR* = 0x0100
    KeyL* = 0x0200
    KeyMask* = 0x03FF

proc keyPoll*() {.inline.} =
    previousKey = currentKey
    currentKey = (not regKeyInput[]) and KeyMask

proc keyIsDown*(key: uint32): uint32 {.inline.} =
    return ((uint32)currentKey) and key
proc keyIsUp*(key: uint32): uint32 {.inline.} =
    return (not (uint32)currentKey) and key

proc keyWasDown*(key: uint32): uint32 {.inline.} = # Uhhh, isn't that the same thing as keyIsDown?
    return ((uint32)currentKey) and key
proc keyWasUp*(key: uint32): uint32 {.inline.} = # Uhhh, isn't that the same thing as keyIsUp?
    return (not (uint32)currentKey) and key


#[regDisplayControl[] = VideoMode3 or BGMode2

for i in 0..<ScreenWidth * ScreenHeight:
    screenBuffer[][i] = 0x001F
    discard

while true: discard]#