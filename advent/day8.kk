module advent/day8

import advent/input
import odo/list

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

fun antennas(Day8(n, m, ps), u: vector<bool>)
    var um := u
    alphabet.foreach fn(c)
        val that-ps = ps.filter-map fn ((c1, x, y)) if c1 == c then Just((x, y)) else Nothing
        that-ps.foreach() fn((x1, y1))
            that-ps.foreach fn((x2, y2))
                if x1 == x2 && y1 == y2 then return ()
                val x = 2 * x2 - x1
                val y = 2 * y2 - y1
                if x < 0 || x >= n || y < 0 || y >= m return ()
                um[x * m + y] := True
    um

fun antennas2(Day8(n, m, ps), u: vector<bool>)
    var um := u
    alphabet.foreach fn(c)
        val that-ps = ps.filter-map fn ((c1, x, y)) if c1 == c then Just((x, y)) else Nothing
        that-ps.foreach() fn((x1, y1))
            that-ps.foreach fn((x2, y2))
                if x1 == x2 && y1 == y2 then return ()
                val dx = x2 - x1
                val dy = y2 - y1
                fun go(x, y)
                    if x < 0 || x >= n || y < 0 || y >= m return ()
                    um[x * m + y] := True
                    go(x + dx, y + dy)
                go(x2, y2)
    um

fun trues(v: vector<bool>): int
    var count := 0
    v.foreach fn(x) if x then count := count + 1
    count

fun part1()
    val p = read-day8()
    val res = p.antennas(vector(p.n * p.m, False))
    println(res.trues)

fun part2()
    val p = read-day8()
    val res = p.antennas2(vector(p.n * p.m, False))
    println(res.trues)


pub fun main()
    with input-full
    part2()