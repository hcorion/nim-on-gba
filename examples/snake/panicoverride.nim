{.push stack_trace: off, profiler:off.}
import ../../gba
import text

proc rawoutput(s: string) =
  drawString((cstring)s, red, 10, 10)
  #var vram = cast[PVIDMem](0xB8000)
  #writeString(vram, "Error: ", makeColor(White, Red), (0, 24))
  #writeString(vram, s, makeColor(White, Red), (7, 24))

proc panic(s: string) =
  rawoutput(s)
  #rawoutput(s)

# Alternatively we also could implement these 2 here:
#
#template sysFatal(exceptn: typeDesc, message: string) =
#  drawString((cstring)message, red, 10, 10)
#template sysFatal(exceptn: typeDesc, message, arg: string) =
#  drawString((cstring)message, red, 10, 10)
#  drawString((cstring)arg, red, 10, 20)


{.pop.}