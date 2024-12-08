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

fun antennas(Day8(n, m, ps))
    alphabet.flatmap fn(c)
        val that-ps = ps.filter-map fn ((c1, x, y)) if c1 == c then Just((x, y)) else Nothing
        that-ps.flatmap fn((x1, y1))
            that-ps.flatmap fn((x2, y2))
                if x1 == x2 && y1 == y2 then return []
                val x = 2 * x2 - x1
                val y = 2 * y2 - y1
                if x < 0 || x >= n || y < 0 || y >= m return []
                [(x, y)]

fun part1()
    val p = read-day8()
    println(p)
    val res = p.antennas.merge-sort.dedup
    println(res)
    println(res.length)


pub fun main()
    with input-full
    part1()