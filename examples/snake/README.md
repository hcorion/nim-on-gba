# Snake Game

![.GIF of snake moving in game.](assets/snake.gif?raw=true ".GIF of snake moving in game.")

This game is a clone of Kyle Halladay's snake game for the GBA.

You can find his C source code here: https://github.com/khalladay/GBASnake
## How to play

Use the start button to proceed through menus.

Use the D-Pad to move the head of the snake.

Collect the yellow square to grow your snake.

## Requirements
- You need to have DevKitPro and DevKitArm installed.
- Nim compiler
## Building and running

It's quite easy, all you need to do is run

```shell
nim c -r nakefile.nim build
```

Now you should have a file called snake.gba, now you can run that in your favourite GBA emulator!

You may have to set the DEVKITPRO and DEVKITARM environmental variables.

## License

Because the original C source code didn't have a license (at the time of writing) I've decided to use MIT.