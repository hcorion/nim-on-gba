{.push stack_trace: off, profiler:off.}
import ../../gba
import text

proc rawoutput(s: string) =
  discard
  drawString((cstring)s, 0x001F, (int)ScreenHeight, 0)
  #var vram = cast[PVIDMem](0xB8000)
  #writeString(vram, "Error: ", makeColor(White, Red), (0, 24))
  #writeString(vram, s, makeColor(White, Red), (7, 24))

proc panic(s: string) =
  rawoutput(s)
  #rawoutput(s)

# Alternatively we also could implement these 2 here:
#
# template sysFatal(exceptn: typeDesc, message: string)
# template sysFatal(exceptn: typeDesc, message, arg: string)



{.pop.}