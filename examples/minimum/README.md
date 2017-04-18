# Minimum Example

This example is a clone of Kyle Halladay's DevKitPro Test written in C.

All this does is sets every pixel of the screen to red.

You can find his C source code here: https://gist.github.com/khalladay/7c86f092a48342adf6d35aa2861b3ed3

## Requirements
- You need to have DevKitPro and DevKitArm installed.
- Nim compiler
## Building and running

It's quite easy, all you need to do is run

```shell
nim c -r nakefile.nim build
```

Now you should have a file called test.gba, now you can run that in your favourite GBA emulator!

You may have to set the DEVKITPRO and DEVKITARM environmental variables.

## License

Because the original C source code didn't have a license (at the time of writing) I've decided to use MIT.