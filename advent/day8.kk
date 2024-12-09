module advent/day8

import advent/input
import odo/list
import std/core/undiv

val alphabet = list('a', 'z') ++ list('A', 'Z') ++ list('0', '9') 

struct day8
    n: int
    m: int
    points: list<(char, int, int)>

fun show(Day8(n, m, ps)): string
    "n: " ++ n.show ++ " ,m: " ++ m.show ++ " points: " ++ ps.show

fun read-day8(): <io, input> day8
    val lines = read-input(8).split("\n")
    val points = lines.flatmap-index fn(i, l)
        l.list.flatmap-index fn (j, c)
            if c == '.' then [] else [(c, i, j)]
    Day8(lines.length, lines.head.default("").count, points)


effect fun mark(x: int, y: int): bool

alias walker<e> = (int, int, int, int) -> <mark, exn|e> unit

fun antennas(Day8(n, m, ps), f: walker<e>): e int
    var um := vector(n * m, False)
    with handler final ctl throw-exn(e) 0
    alphabet.foreach fn(c)
        val that-ps = ps.filter-map fn ((c1, x, y)) if c1 == c then Just((x, y)) else Nothing
        that-ps.foreach() fn((x1, y1))
            that-ps.foreach fn((x2, y2))
                if x1 == x2 && y1 == y2 then return ()
                with fun mark(ux, uy)
                    if ux < 0 || ux >= n || uy < 0 || uy >= m return False
                    um[ux * m + uy] := True
                    True
                f(x1, y1, x2, y2)

    um.trues

fun trues(v: vector<bool>): int
    var count := 0
    v.foreach fn(x) if x then count := count + 1
    count

fun solve(f) read-day8().antennas(f)

fun part1()
    solve fn(x1, y1, x2, y2) if mark(2 * x2 - x1, 2 * y2 - y1) then ()
    
fun part2()
    solve fn (x1, y1, x2, y2)
        val dx = x2 - x1
        val dy = y2 - y1
        fun go(x, y) if mark(x, y) then go(x + dx, y + dy)
        go(x2, y2)

pub fun main()
    with input-full
    part2()