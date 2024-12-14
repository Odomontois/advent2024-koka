module advent/day14

import advent/input
import odo/maybe

fun list-pair([x, y]) (x, y)

fun parse-point(s)
    s.slice.drop(2).string.split(",").filter-map(fn (x) x.parse-int).list-pair

fun parse-robot(s)
    s.split(" ").map(parse-point).list-pair

fun read-robots()
    read-input(14).lines.map(parse-robot)

fun simulate(((sx, sy), (vx, vy)), time, (wx, wy))
    ((sx + vx * time) % wx, (sy + vy * time) % wy)

fun dims()
    match input() 
        "sample" -> (11, 7)
        "full" -> (101, 103)

fun side(x, ws) 
    match cmp(x, ws / 2) 
        Lt -> Just(0)
        Gt -> Just(1)
        Eq -> Nothing
fun part1()
    val d as (wx, wy) = dims()
    var qs := vector(4, 0)
    read-robots().map fn(r) 
        val (x, y) = r.simulate(100, d)
        foreach(side(x, wx)) fn(sx) 
            foreach(side(y, wy)) fn(sy)
                qs[2 * sx + sy] := qs[2 * sx + sy] + 1
    qs.list.foldl(1) fn(x, y) x * y

        

    

pub fun main()
    with input-full
    part1()
