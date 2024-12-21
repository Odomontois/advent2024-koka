module advent/day21

import advent/input
import odo/list
import odo/choice

fun sequences() read-input(21).split("\n")

fun numeric(c): total _ match c
    '7' -> (0, 0)
    '8' -> (1, 0)
    '9' -> (2, 0)
    '4' -> (0, 1)
    '5' -> (1, 1)
    '6' -> (2, 1)
    '1' -> (0, 2)
    '2' -> (1, 2)
    '3' -> (2, 2)
    '0' -> (1, 3)
    'A' -> (2, 3)
    _ -> (0, 3)

fun directional(c): total _ match c
    '^' -> (1, 0)
    'A' -> (2, 0)
    '<' -> (0, 1)
    'v' -> (1, 1)
    '>' -> (2, 1)
    _   -> (0, 0)

fun one-dir-move(d, cn, cp)
    (if d < 0 then cn else cp).repeat(abs(d))

fun move(dx, dy, gap-warning: bool) 
    val xmove = one-dir-move(dx, "<", ">")
    val ymove = one-dir-move(dy, "^", "v")
    if !gap-warning
    then xmove ++ ymove ++ "A"
    else ymove ++ xmove ++ "A"

fun hv-move(px, py, x, y) 
    ((x, y), one-dir-move(x - px, "<", ">") ++ one-dir-move(y - py, "^", "v") ++ "A")

fun vh-move(x, y, px, py) 
    (one-dir-move(y - py, "^", "v") ++ one-dir-move(x - px, "<", ">") ++ "A", (x, y), )

fun translate(s: string, pad: char -> (int, int)): string
    val (gx, gy) = pad(' ')
    s.list.map(pad).foldl(("", pad('A'))) fn ((acc, (px, py)), (x, y))
        val gap-warning = (py == gy) && (x == gx) 
        (acc ++ move(x - px, y - py, gap-warning), (x, y))
    .fst

fun translate-c(s: string, pad: char -> (int, int)): choice string
    val (gx, gy) = pad(' ')
    s.list.map(pad).foldl((Nil, pad('A'))) fn ((acc, (px, py)), (x, y))
        val gap-x = (py == gy) && (x == gx) 
        val gap-y = (px == gx) && (y == gy)
        val hv = one-dir-move(x - px, "<", ">") ++ one-dir-move(y - py, "^", "v") ++ "A"
        val vh = one-dir-move(y - py, "^", "v") ++ one-dir-move(x - px, "<", ">") ++ "A"
        val hv-res = (Cons(hv, acc), (x, y))
        val vh-res = (Cons(vh, acc), (x, y))
        if gap-y || y == py then hv-res
        else if gap-x || x == px then vh-res
        else if choice() then hv-res else vh-res
    .fst.join

fun trans2(s: string) s.translate(numeric).translate(directional).translate(directional)
fun trans2-c(s: string) 
    fun look()
        val r = s.translate-c(numeric).translate-c(directional).translate-c(directional)
        (r, r.count)
    choice/fold(look) fn (p1 as (_, c1), p2 as (_, c2)) if c1 < c2 then p1 else p2 



fun part1() 
    sequences().map fn(s)
        val (t, c) = s.trans2-c
        val d = s.replace-all("A", "").parse-int.default(0)
        println(s ++ "  " ++ t ++ " :" ++  c.show ++ "," ++ d.show)
        t.count * d
    .sum


pub fun main()
    with input-full
    part1()