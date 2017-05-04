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
    # Other stuff I'm not sure about.
    MappingMode1D* = 0x0040

# Code for sprite packing if we need it: 
# import macro
#template declThePragma(): untyped =
#  {.pragma: alig, codegenDecl: "$# $# __attribute__((aligned(4)))".}

#declThePragma()

var
    regDisplayControl* {.volatile.} = cast[ptr uint32](MemIO)
    screenBuffer* = cast[ptr array[(int)ScreenWidth * ScreenHeight, uint16]](MemVRAM)
    regVCount* {.volatile.} = cast[ptr uint16](RegVCountAddr)
    regIME* {.volatile.} = cast[ptr uint16](RegIMEAddr)
    regIE* {.volatile.} = cast[ptr uint16](RegIEAddr)
    regDispStat* {.volatile.} = cast[ptr uint16](RegDispStatAddr)
    regKeyInput* {.volatile.} = cast[ptr uint32](RegKeyInputAddr)

# Background Control flags
# See the backgrounds example for some basic usage of bg 0 and 1.
# The ScrollH and ScrollV flags are write only.
var
    # Background 0
    regBG0Control* {.volatile.} = cast[ptr uint16](MemIO + 8)
    regBG0ScrollH* {.volatile.} = cast[ptr uint16](MemIO + 0x10)
    regBG0ScrollV* {.volatile.} = cast[ptr uint16](MemIO + 0x12)
    # Background 1
    regBG1Control* {.volatile.} = cast[ptr uint16](MemIO + 0xA)
    regBG1ScrollH* {.volatile.} = cast[ptr uint16](MemIO + 0x14)
    regBG1ScrollV* {.volatile.} = cast[ptr uint16](MemIO + 0x16)
    # Background 2
    regBG2Control* {.volatile.} = cast[ptr uint16](MemIO + 0xC)
    regBG2ScrollH* {.volatile.} = cast[ptr uint16](MemIO + 0x18)
    regBG2ScrollV* {.volatile.} = cast[ptr uint16](MemIO + 0x1A)
    # Background 3
    regBG3Control* {.volatile.} = cast[ptr uint16](MemIO + 0xE)
    regBG3ScrollH* {.volatile.} = cast[ptr uint16](MemIO + 0x1C)
    regBG3ScrollV* {.volatile.} = cast[ptr uint16](MemIO + 0x1E)

# Timers
# Great documentation here:
# https://www.coranac.com/tonc/text/timers.htm
# I'm not sure if these work, I wasn't able to get them working.
var
    regTimer0Control* {.volatile.}= cast[ptr uint16](MemIO + 0x0100)
    regTimer0Data* {.volatile.}= cast[ptr uint16](MemIO + 0x0102)
    regTimer1Control* {.volatile.}= cast[ptr uint16](MemIO + 0x0104)
    regTimer1Data* {.volatile.}= cast[ptr uint16]((MemIO + 0x0106))
    regTimer2Control* {.volatile.}= cast[ptr uint16](MemIO + 0x0108)
    regTimer2Data* {.volatile.}= cast[ptr uint16](MemIO + 0x010A)
    regTimer3Control* {.volatile.}= cast[ptr uint16](MemIO + 0x010C)
    regTimer3Data* {.volatile.}= cast[ptr uint16](MemIO + 0x010E)
const
    TimerFreqSys*    = 0 # System clock timer (16.7 Mhz)
    TimerFreq1*      = 0 # 1 cycle/tick (16.7 Mhz)
    TimerFreq64*     = 0x0001 # 64 cycles/tick (262 kHz)
    TimerFreq256*    = 0x0002 # 256 cycles/tick (66 kHz)
    TimerFreq1024*   = 0x0003 # 1024 cycles/tick (16 kHz)
    TimerCascade*    = 0x0004 # Increment when preceding timer overflows
    TimerIRQ*        = 0x0040 # Enable timer irq
    TimerEnable*     = 0x0080 # Enable timer

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