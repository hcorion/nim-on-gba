import ../../gba
import text

var titleOn* = true

proc beginTitleScreen*() =
    titleOn = true
    drawRect(0, 0, ScreenWidth, ScreenHeight, lime)
    drawString("GBA SNAKE\nTHE BEST GAME", black, 40, 40)
    drawString("!@#$%^&*()_+-={}|[]\\:\";\'<>?,./", black, 0, 50)
    drawString("qwertyuiopasdfghjklzxcvbnm", black, 0, 60)
    drawString("QWERTYUIOPASDFGHJKLZXCVBNM", black, 0, 70)

proc handleTitleInput*() =
    if currentKey != previousKey:
        if keyIsDown(KeyStart) > 0'u32:
            titleOn = false