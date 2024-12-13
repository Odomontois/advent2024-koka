module advent/day13

import advent/input
import odo/maybe

alias pair = (int, int)

struct machine
    button-a: pair
    button-b: pair
    prize: pair

fun show(Machine(a, b, p): machine) "Machine( button-a: " ++ a.show ++ ", button-b: " ++ b.show ++ ", prize: " ++ p.show ++ " )"

fun parse-pair(line)
    val [_, p] = line.split(": ")
    val [x, y] = p.split(", ").filter-map(fn(s) s.slice.drop(2).string.parse-int)
    (x, y)

fun parse-machine(block)
    val [ba, bb, p] = block.split("\n").map(parse-pair)
    Machine(ba, bb, p)

fun parse-machines()
    read-input(13).split("\n\n").map(parse-machine)

fun solve-machine(Machine((ax, ay), (bx, by), (px, py)))
    fun try-simple(x, y)
        whether(px % x == 0 && py % y == 0 && px / x == py / y)
            px / x
    val simple = try-simple(ax, ay) || try-simple(bx, by)
    if simple.is-just then return simple

    // a * ax + b * bx = px
    // a * ay + b * by = py
    // a = (px - b * bx) / ax
    // (px - b * bx) * ay / ax + b * by = py
    // px * ay - b * bx * ay + b * by * ax = py * ax
    // b * (by * ax - bx * ay) = px * ay - py * ax
    // b = (px * ay - py * ax) / (by * ax - bx * ay)

    val qb = by * ax - bx * ay //  67 * 94 - 22 * 34 = 5550
    val tb = py * ax - px * ay  // 5400 * 94 - 8400 * 34 = 222000
    if qb == 0 || tb % qb != 0 then return Nothing
    val b = tb / qb // 222000 / 5550 = 40
    val ta = px - b * bx // 8400 - 40 * 22 = 7520
    if ta % ax != 0 then return Nothing
    val a = ta / ax // 7520 / 94 = 80
    Just (a * 3 + b)



pub fun main()
    with input-full
    parse-machines().filter-map(solve-machine).sum
