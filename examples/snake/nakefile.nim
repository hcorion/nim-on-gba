import nake
import os

task "build", "Build gameboy executable.":
  shell "nim c -d:release --opt:speed --out:gba main.nim"
  shell "/Users/zionnimchuk/devkitPro/devkitARM/bin/arm-none-eabi-objcopy -O binary gba first.gba"
  shell "/Users/zionnimchuk/devkitPro/devkitARM/bin/gbafix first.gba"

task "clean", "Removes build files":
  removeDir "nimcache"