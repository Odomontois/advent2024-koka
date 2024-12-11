module advent/day11

import advent/input

fun stones() 
    read-input(11).split(" ").filter-map fn(x) x.parse-int

fun count(x, ticks)
    if ticks == 0 then return 1
    if x == 0 then return count(1, ticks - 1)
    val d = x.count-digits()
    if d % 2 == 1 then return count(x * 2024, ticks - 1)
    val (a, b) = x.divmod-exp10(d / 2)
    count(a, ticks - 1) + count(b, ticks - 1)

fun part1()
    stones().map(fn (x) x.count(25)).sum

pub fun main()
    with input-full
    part1()
    