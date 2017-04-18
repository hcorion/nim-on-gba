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

import os
import nake
import ../../devkitpro

const MainFileName = "main.nim"
const OutputFileName = "test"

const CFlags = "-IDEVKITPRO/libgba/include -IDEVKITARM/arm-none-eabi/include"
const LFlags = "-specs=DEVKITARM/arm-none-eabi/lib/gba.specs"
const ExtraFlags = "-d:release --opt:speed --out:" & OutputFileName
const GCCFlags =  " --gcc.exe:DEVKITARM/bin/arm-none-eabi-gcc --gcc.linkerexe:DEVKITARM/bin/arm-none-eabi-gcc"
const BasicCompilerFlags = GCCFlags & " --passC:\"" & CFlags & "\" --passL:" & LFlags

task "build", "Build gameboy executable.":
  # We need to detect devkitpro and devkitarm
  detectDevKit()

  var compilerFlags = replace(BasicCompilerFlags, "DEVKITARM", devKitArmPath)
  compilerFlags = compilerFlags.replace("DEVKITPRO", devKitProPath)

  shell "nim c " & ExtraFlags & " " & compilerFlags & " " & MainFileName
  shell devKitArmPath & "/bin/arm-none-eabi-objcopy -O binary " & OutputFileName & " " & OutputFileName & ".gba"
  shell devKitArmPath & "/bin/gbafix " & OutputFileName & ".gba"

task "clean", "Removes build files":
  removeDir "nimcache"
  removeFile OutputFileName
  removeFile OutputFileName & ".gba"