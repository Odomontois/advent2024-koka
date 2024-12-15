module advent/day15

import advent/input
import odo/list

type direction
    U
    D
    L
    R

fun direction/show(d) match d
    U -> "↑"
    D -> "↓"
    L -> "←"
    R -> "→"

type cell 
    Empty
    Wall
    Bx

alias point = (int, int)

fun idx((x, y), ?dim: int): int
    y * dim + x

fun cell/show(c) match c
    Empty -> " "
    Wall -> "▓"
    Bx -> "▢"

struct grid
    dim: int
    pos: point
    data: vector<cell>

fun grid/show(Grid(dim, start, data): grid): string
    data.list.map-indexed(fn(i, c) 
        val (x, y) = (i % dim, i / dim)
        val pref = if x == 0 then "\n" else ""
        pref ++ (if (x, y) == start then "☺" else c.show())
    ).join

value struct input15
    grid: grid
    commands: list<direction>

fun input15/show(Input15(grid, commands): input15): string
    "Input15(" ++ grid.show() ++ ", " ++ commands.show() ++ ")"

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
                'O' -> Bx
                '@' -> 
                    grid-start := (x, y)
                    Empty
            grid-data[y * dim + x] := cell
            x := x + 1

    val commands = comms.list.collect fn(c) match c
        '^' -> U
        'v' -> D
        '<' -> L
        '>' -> R

    Input15(Grid(dim, grid-start, grid-data), commands)


fun move-cell(data: vector<cell>, from: point, to: point, ?dim: int): _ vector<cell>
    var data' := data
    data'[to.idx] := data'[from.idx]
    data'[from.idx] := Empty
    data'


fun move(Grid(dim, pos as (x, y), data), c: direction): _ grid
    val (dx, dy) = match c
        U -> (0, -1)
        D -> (0, 1)
        L -> (-1, 0)
        R -> (1, 0)

    var data' := data
    val next = (x + dx, y + dy)
    fun find-cell(m as (u, v)) match data'[v * dim + u]
        Empty -> Just(m)
        Bx -> find-cell((u + dx, v + dy))
        Wall -> Nothing
    
    match data[next.idx]
        Wall -> 
            return Grid(dim, pos, data')
            ()
        Bx -> match find-cell(next)
            Nothing ->        
                return Grid(dim, pos, data')
                ()
            Just(m) ->
                data' := data'.move-cell(next, m)
        Empty -> ()


    data' := data'.move-cell(pos, next)
    
    Grid(dim, next, data')

fun gps-sum(Grid(dim, _, data)): int
    var sum := 0
    data.foreach-indexed fn(i, c)
        val (x, y) = (i % dim, i / dim)
        match c 
            Bx -> sum := sum + x + y * 100
            _ -> ()
    sum

fun part1()
    val Input15(grid, commands) = read-data()
    commands.foldl(grid, move).gps-sum   




pub fun main()
    with input-full
    part1()