# Nim On GBA

Are you tired of writing your Game Boy Advanced code in C?

Wouldn't you love to write your GBA code in python-esque syntax?

Well now you can!

Inspired by http://kylehalladay.com/blog/tutorial/2017/03/28/GBA-By-Example-1.html


## Examples (mostly ports of games written in C)

All examples require the nake package installed via nimble `nimble install nake`

- Minimum (port of https://gist.github.com/khalladay/7c86f092a48342adf6d35aa2861b3ed3)
- Snake (port of https://github.com/khalladay/GBASnake)
- Sprite (port of Kyle Halladay's tutorial here: http://kylehalladay.com/blog/tutorial/2017/04/04/GBA-By-Example-2.html)
- Background (port of Kyle Halladay's tutorial)

## Resources
- [GitHub Gist of tiny GBA example in C](https://gist.github.com/khalladay/7c86f092a48342adf6d35aa2861b3ed3)
- https://github.com/khalladay/GBASnake
- https://www.coranac.com/tonc/text/toc.htm
- https://github.com/dom96/nimkernel
- http://www.coranac.com/documents/taptngba/

## Possible future endeavours

Target original gameboy using SDCC: https://en.wikipedia.org/wiki/Small_Device_C_Compiler

Target Virtual Boy using gccVB: http://www.planetvb.com/modules/tech/?sec=tools&pid=gccvb

## License
The main gba.nim file is licensed under the MIT license.

Some of the examples may be under a different license, because if it's a clone of a game/demo I'll honour the original dev and keep the same license.
