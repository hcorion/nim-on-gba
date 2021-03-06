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

import ../../gba, game, text

const 
    SnakeLeft* = 0
    SnakeRight* = 2
    SnakeUp* = 0
    SnakeDown* = 2
    SnakeStopped* = 1

type
    SnakeNode* = object
        prev: ptr SnakeNode
        x*, y*: int
    Snake* = object
        head*: SnakeNode
        tail*: ptr SnakeNode
        freeNodes: array[(int) NumCellsX*NumCellsY, SnakeNode]
        length*: uint
        velocity: Vector2
        lastMove: Vector2

proc init*(snake: var Snake, start: Vector2, maxLen: uint) =
    snake.head.x = start.x
    snake.head.y = start.y
    snake.length = 1
    snake.velocity.x = SnakeRight
    snake.velocity.y = SnakeStopped
    snake.lastMove.x = SnakeRight
    snake.lastMove.y = SnakeStopped
    snake.tail = addr(snake.head)
    snake.tail[].prev = nil
    for i in 0..<snake.freeNodes.len:
        var n: SnakeNode
        snake.freeNodes[i] = n

proc update*(snake: var Snake): bool =
    ## Updates the snake
    ## Returns true if the snake has hit itself.
    ## False if all is good.
    var curNode = snake.tail
    while curNode != nil:
        var prev = curNode.prev
        if prev != nil:
            curNode.x = prev.x
            curNode.y = prev.y
            curNode = curNode.prev
        else:
            var new: Vector2 = (
                x: curNode.x + (snake.velocity.x - 1),
                y: curNode.y + (snake.velocity.y - 1) )
            if getCellValue(new) == 1'u8:
                return true
            curNode.x = new.x
            curNode.y = new.y
            snake.lastMove = snake.velocity
            new.setCellValue(1)
            break
    return false

proc addNode*(snake: var Snake) =
    snake.freeNodes[snake.length-1].x = snake.tail.x
    snake.freeNodes[snake.length-1].y = snake.tail.y
    snake.freeNodes[snake.length-1].prev = snake.tail

    snake.tail = addr(snake.freeNodes[snake.length-1])
    snake.length += 1

proc drawLooseNode(node: SnakeNode, gridOffset, nodeSize: uint) =
    drawRect2(
        gridOffset + ((uint)node.x) * nodeSize, 
        gridOffset + ((uint)node.y) * nodeSize, 
        nodeSize, nodeSize, yellow
    )
proc clearLooseNode(node: SnakeNode, gridOffset, nodeSize: uint) = 
    drawRect2(
        gridOffset + ((uint)node.x) * nodeSize, 
        gridOffset + ((uint)node.y) * nodeSize, 
        nodeSize, nodeSize, black
    )
proc isCollidingWithNode(snake: Snake, node: SnakeNode): bool =
    return snake.head.x == node.x and snake.head.y == node.y

proc updateVelocityX*(snake: var Snake, velocity: int) = 
     if snake.lastMove.x == SnakeStopped:
         snake.velocity.x = velocity
         snake.velocity.y = SnakeStopped

proc updateVelocityY*(snake: var Snake, velocity: int) = 
     if snake.lastMove.y == SnakeStopped:
         snake.velocity.x = SnakeStopped
         snake.velocity.y = velocity