# Background Example

This example is a clone of Kyle Halladay's background tutorial written in C.

This program uses video mode 0 to display two different backgrounds at the same time moving across the screen horizontally.

You can find the tutorial here: http://kylehalladay.com/blog/tutorial/2017/04/11/GBA-By-Example-3.html

## Requirements
- You need to have DevKitPro and DevKitArm installed.
- Nim compiler
## Building and running

It's quite easy, all you need to do is run

```shell
nim c -r nakefile.nim build
```

Now you should have a file called background.gba, now you can run that in your favourite GBA emulator!

You may have to set the DEVKITPRO and DEVKITARM environmental variables.

## License

Because the original C source code didn't have a license (at the time of writing) I've decided to use MIT.