module advent/day15

import advent/input

type direction
    Up
    Down
    Left
    Right

type cell 
    Empty
    Wall
    Box

struct grid
    dim: int
    start: (int, int)
    data: vector<cell>

value struct input15
    grid: grid
    commands: list<direction>

fun read-data()
    val [gr, comms] = read-input(15).split("\n\n")
    val lines = gr.split("\n")
    val dim = lines.length
    var grid-data := vector(dim * dim, Empty)
    var grid-start := (0, 0)
    var x := 0
    lines.foreach-indexed fn(y, line)
        x := 0
        line.foreach fn(c)
            val cell = match c
                '.' -> Empty
                '#' -> Wall
                'B' -> Box
                '@' -> 
                    grid-start := (x, y)
                    Empty
            grid-data[y * dim + x] := cell
            x := x + 1

    val commands = comms.list.filter-map fn(c) match c
            'U' -> Just(Up)
            'D' -> Just(Down)
            'L' -> Just(Left)
            'R' -> Just(Right)
            _ -> Nothing
    

    Input15(Grid(dim, grid-start, grid-data), commands)


pub fun main()
    "Hello world"