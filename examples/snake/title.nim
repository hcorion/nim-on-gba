import ../../gba
import text

var titleOn* = true

proc beginTitleScreen*() =
    titleOn = true
    drawRect(0, 0, ScreenWidth, ScreenHeight, lime)
    drawString("GBA SNAKE\0", black, 40, 40)

proc handleTitleInput*() =
    if currentKey != previousKey:
        if keyIsDown(KeyStart) > 0'u32:
            titleOn = false