module advent/day15

import advent/input
import odo/list
import odo/queue
import std/os/readline

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
    LSide
    RSide

fun cell/(==)(c1, c2) match (c1, c2)
    (Empty, Empty) -> True
    (Wall, Wall) -> True
    (Bx, Bx) -> True
    _ -> False
    
alias point = (int, int)

fun idx((x, y), ?dim: int): int
    y * dim + x

fun cell/show(c): string match c
    Empty -> "·"
    Wall -> "▓"
    Bx -> "▢"
    LSide -> "◨"
    RSide -> "◧"

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
                '[' -> LSide
                ']' -> RSide
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

fun point/(+)((x, y), (dx, dy)): point
    (x + dx, y + dy)

val to-left = (-1, 0)
val to-right = (1, 0)

fun move(Grid(dim, pos, data), c: direction): _ grid
    val d = match c
        U -> (0, -1)
        D -> (0, 1)
        L -> (-1, 0)
        R -> (1, 0)

    var data' := data
    val next = pos + d

    var moved := vector(dim * dim, False)
    var saved := vector(dim * dim, False)

    var ms := queue([next])
    var save-acc := Nil

    fun put(m)
        if moved[m.idx] then return ()
        moved[m.idx] := True
        ms := ms.enqueue(m)

    fun pop()
        match ms.dequeue
            Just((m, ms')) -> 
                ms := ms'
                Just(m)
            Nothing -> Nothing

    fun save(m)
        if saved[m.idx] then return ()
        saved[m.idx] := True
        save-acc := Cons(m, save-acc)

    fun move-boxes(): _ bool
        match pop()
            Nothing -> True
            Just(m) -> 
                match data'[m.idx]
                    Wall -> return False
                    Bx    -> 
                        put(m + d)
                        save(m)
                    LSide -> 
                        if d.fst == 0  
                            then   
                                put(m + d + to-right)
                                put(m + d) 
                            else put(m + d + d)
                        save(m)
                        save(m + to-right)
                    RSide -> 
                        if d.fst == 0  
                            then 
                                put(m + d + to-left)
                                put(m + d) 
                            else put(m + d + d)
                        save(m)
                        save(m + to-left)
                    Empty -> ()
                move-boxes()

    if move-boxes() then
            save-acc.foreach fn(m)
                data' := data'.move-cell(m, m + d)
            Grid(dim, next, data')
    else Grid(dim, pos, data')
    
    

fun gps-sum(Grid(dim, _, data)): int
    var sum := 0
    data.foreach-indexed fn(i, c)
        val (x, y) = (i % dim, i / dim)
        val is-box = match c 
            Bx -> True
            LSide -> True
            _ -> False
        if is-box then sum := sum + x + y * 100
    sum

fun stretch(Grid(dim, (x, y), data))
    val data' = data.list.flatmap fn(c) match c
        Bx -> [LSide, RSide]
        c -> [c, c]
    .vector
    Grid(dim * 2, (x * 2, y), data')

fun solve(f: grid -> grid = id)
    val Input15(grid, commands) = read-data()
    val res = commands.foldl(f(grid)) fn(g, c) 
        // println(g)
        // println(c)
        // readline().ignore
        g.move(c)
    println(res)
    res.gps-sum    

fun part1() solve()

fun part2() solve(stretch)


pub fun main()
    with input-full
    part2()