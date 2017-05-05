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

var devKitArmPath*: string = nil
var devKitProPath*: string = nil
# From here down could use some extra procedures to keep things cleaner.

proc detectDir(dir: string) = 
  ## Basically checks if a file exists, if it doesn't then quit immediately.
  if not dirExists(dir):
    echo "Error: desired path, " & dir & " was not found. Stopping."
    quit(QuitFailure)

proc detectFile(filePath: string) =
  ## Basically checks if a file exists, if it doesn't then quit immediately.
  if not fileExists(filePath):
    echo "Error: desired file, " & filePath & " was not found. Stopping."
    quit(QuitFailure)

proc checkDevKitPro(path: string) =
  detectDir(path & "/libgba/include")

proc checkDevKitArm(path: string) =
  detectDir(path & "/arm-none-eabi/include")
  detectFile(path & "/arm-none-eabi/lib/gba.specs")
  detectFile(path & "/bin/arm-none-eabi-gcc")

proc detectDevKit*() =
  if existsEnv("DEVKITPRO"):
    echo "DevKitPro Environment variable found."
    devKitProPath = getEnv("DEVKITPRO")
    # Check to make sure the path contains what we want.
    checkDevKitPro(devKitProPath)
  else:
    echo "DevKitPro environmental variable not found, attempting automatic detection."
    case hostOS:
      of "macosx", "linux":
        var possibleDevKitPro = getHomeDir() & "devkitPro"
        if not dirExists(possibleDevKitPro):
          echo "Tried path " & possibleDevKitPro & " but it doesn't exist."
          echo "To install DevKitPro on " & hostOS & " you can download a auto-installing perl script here: "
          echo "https://sourceforge.net/projects/devkitpro/files/Automated%20Installer/devkitARMupdate.pl/download"
          quit(QuitFailure)
        else:
          checkDevKitPro(possibleDevKitPro)
          echo "Successfully detected DevKitPro path on MacOS"
          devKitProPath = possibleDevKitPro
      of "Windows":
        echo "Automatic detection of DevKitPro has not yet been implemented for Windows."
        echo "Feel free to make a Pull Request!"
        quit(QuitFailure)
      else:
        echo "Automatic detection of DevKitPro has not yet been implemented for " & hostOS & "."
        echo "Feel free to make a Pull Request!"
        quit(QuitFailure)

        
    
  if existsEnv("DEVKITARM"):
    echo "DevKitArm Environment variable found."
    devKitArmPath = getEnv("DEVKITARM")
    # Check to make sure the path contains what we want.
    checkDevKitArm(devKitArmPath)
  else:
    echo "DevKitArm environmental variable not found, attempting automatic detection."
    case hostOS:
      of "macosx", "linux":
        var possibleDevKitArm = getHomeDir() & "devkitPro/devkitARM"
        if not dirExists(possibleDevKitArm):
          echo "Tried path " & possibleDevKitArm & " but it doesn't exist."
          echo "To install DevKitArm on MacOS you can download a auto-installing perl script here: "
          echo "https://sourceforge.net/projects/devkitpro/files/Automated%20Installer/devkitARMupdate.pl/download"
          quit(QuitFailure)
        else:
          checkDevKitArm(possibleDevKitArm)
          echo "Successfully detected DevKitArm path on MacOS"
          devKitArmPath = possibleDevKitArm
      of "Windows":
        echo "Automatic detection of DevKitArm has not yet been implemented for Windows."
        echo "Feel free to make a Pull Request!"
        quit(QuitFailure)
      else:
        echo "Automatic detection of DevKitArm has not yet been implemented for " & hostOS & "."
        echo "Feel free to make a Pull Request!"
        quit(QuitFailure)