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


fun has-long-line(^g: vector<int>) 
    val (wx, wy) = dims()
    var c := 0
    for-while(wx * wy) fn(i)
        if g[i] > 0 then c := c + 1 else c := 0
        if c > 10 then return Just(True) else Nothing
    .default(False)

fun part2()
    val d as (wx, wy) = dims()
    var rs := read-robots()
    var grid := vector(wx * wy, 0)

    fun grid-change(x, y, c)
        val k = y * wx + x
        grid[k] := grid[k] + c
    rs.foreach fn (((x, y), _)) grid-change(x, y, 1)
    fun go(step)
        if has-long-line(grid) then return step
        rs.foreach fn (((x, y), _)) grid-change(x, y, -1)
        rs := rs.map fn(r) (r.simulate(1, d), r.snd)
        rs.foreach fn (((x, y), _)) grid-change(x, y, 1)
        go(step + 1)

    go(0)
   

    

pub fun main()
    with input-full
    part2()
