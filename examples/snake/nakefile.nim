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

import nake
import os

const MainFileName = "main.nim"
const OutputFileName = "snake"

const CFlags = "-IDEVKITPRO/libgba/include -IDEVKITARM/arm-none-eabi/include"
const LFlags = "-specs=DEVKITARM/arm-none-eabi/lib/gba.specs"
const ExtraFlags = "-d:release --opt:speed --out:" & OutputFileName
const GCCFlags =  " --gcc.exe:DEVKITARM/bin/arm-none-eabi-gcc --gcc.linkerexe:DEVKITARM/bin/arm-none-eabi-gcc"
const BasicCompilerFlags = GCCFlags & " --passC:\"" & CFlags & "\" --passL:" & LFlags

var devKitArmPath: string = nil
var devKitProPath: string = nil

proc detectDevKit() # Implementation at the bottom of the file.

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


# From here down could use some extra procedures to keep things cleaner.

proc checkDevKitPro(path: string) =
  if not dirExists(path & "/libgba/include"):
    echo "Error: DEVKITPRO environment variable found, but desired path, " & path & "/libgba/include was not found. Stopping."
    quit()

proc checkDevKitArm(path: string) =
  if not dirExists(devKitArmPath & "/arm-none-eabi/include"):
    echo "Error: DEVKITARM environment variable found, but desired path, " & devKitArmPath & "/arm-none-eabi/include was not found. Stopping."
    quit()
  if not fileExists(devKitArmPath & "/arm-none-eabi/lib/gba.specs"):
    echo "Error: DEVKITARM environment variable found, but desired file, " & devKitArmPath & "/arm-none-eabi/lib/gba.specs was not found. Stopping."
    quit()
  if not fileExists(devKitArmPath & "/bin/arm-none-eabi-gcc"):
    echo "Error: DEVKITARM environment variable found, but desired file, " & devKitArmPath & "/bin/arm-none-eabi-gcc was not found. Stopping."
    quit()

proc detectDevKit() =
  if existsEnv("DEVKITPRO"):
    echo "DevKitPro Environment variable found."
    devKitProPath = getEnv("DEVKITPRO")
    # Check to make sure the path contains what we want.
    checkDevKitPro(devKitProPath)
  else:
    echo "DevKitPro Evironmental variable not found, attempting automatic detection."
    case hostOS:
      of "macosx":
        var possibleDevKitPro = getHomeDir() & "devkitPro"
        if not dirExists(possibleDevKitPro):
          echo "Tried path " & possibleDevKitPro & " but it doesn't exist."
          echo "To install DevKitPro on MacOS you can download a auto-installing perl script here: "
          echo "https://sourceforge.net/projects/devkitpro/files/Automated%20Installer/devkitARMupdate.pl/download"
          quit()
        else:
          checkDevKitPro(possibleDevKitPro)
          echo "Successfully detected DevKitPro path on MacOS"
          devKitProPath = possibleDevKitPro
      of "linux":
        echo "Automatic detection of DevKitPro has not yet been implemented for Linux."
        echo "Feel free to make a Pull Request!"
        quit()
      of "Windows":
        echo "Automatic detection of DevKitPro has not yet been implemented for Windows."
        echo "Feel free to make a Pull Request!"
        quit()
      else:
        echo "Automatic detection of DevKitPro has not yet been implemented for " & hostOS & "."
        echo "Feel free to make a Pull Request!"
        quit()

        
    
  if existsEnv("DEVKITARM"):
    echo "DevKitArm Environment variable found."
    devKitArmPath = getEnv("DEVKITARM")
    # Check to make sure the path contains what we want.
    checkDevKitArm(devKitArmPath)
  else:
    echo "DevKitArm Evironmental variable not found, attempting automatic detection."
    case hostOS:
      of "macosx":
        var possibleDevKitArm = getHomeDir() & "devkitPro/devkitARM"
        if not dirExists(possibleDevKitArm):
          echo "Tried path " & possibleDevKitArm & " but it doesn't exist."
          echo "To install DevKitArm on MacOS you can download a auto-installing perl script here: "
          echo "https://sourceforge.net/projects/devkitpro/files/Automated%20Installer/devkitARMupdate.pl/download"
          quit()
        else:
          checkDevKitArm(possibleDevKitArm)
          echo "Successfully detected DevKitArm path on MacOS"
          devKitArmPath = possibleDevKitArm
      of "linux":
        echo "Automatic detection of DevKitArm has not yet been implemented for Linux."
        echo "Feel free to make a Pull Request!"
        quit()
      of "Windows":
        echo "Automatic detection of DevKitArm has not yet been implemented for Windows."
        echo "Feel free to make a Pull Request!"
        quit()
      else:
        echo "Automatic detection of DevKitArm has not yet been implemented for " & hostOS & "."
        echo "Feel free to make a Pull Request!"
        quit()