module advent/day21

import advent/input
import odo/list
import odo/choice

fun sequences() read-input(21).split("\n")

alias pad = char -> (int, int)

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

fun dir-index(c): total _ match c
    'A' -> 0
    '^' -> 1
    '<' -> 2
    'v' -> 3
    '>' -> 4
    _   -> -1000

fun index-dir(c): total _ match c
    0 -> 'A'
    1 -> '^'
    2 -> '<'
    3 -> 'v'
    4 -> '>'
    _ -> ' '

alias cost-matrix = vector<vector<int>>


fun cost-of(from: char, to: char, ?costs: cost-matrix): int
    with final ctl throw-exn(e) -10000000000
    costs[dir-index(from)][dir-index(to)]

val initial-cost-matrix: cost-matrix = vector(5, vector(5, 1))

fun calculate-cost(moves: string, ?costs: cost-matrix): int
    moves.list.foldl((0, 'A'), fn ((acc, prev), c) (acc + cost-of(prev, c), c)).fst

fun one-dir-move(d, cn, cp)
    (if d < 0 then cn else cp).repeat(abs(d))

fun move-cost(from: char, to: char, ?pad: pad, ?costs: cost-matrix): int
    val (fx, fy) = pad(from)
    val (tx, ty) = pad(to)
    val (gx, gy) = pad(' ')
    val gap-x = (fy == gy) && (tx == gx) 
    val gap-y = (fx == gx) && (ty == gy)
    val hmove = one-dir-move(tx - fx, "<", ">")
    val vmove = one-dir-move(ty - fy, "^", "v")
    val hv = calculate-cost(hmove ++ vmove ++ "A")
    val vh = calculate-cost(vmove ++ hmove ++ "A")
    if gap-y then hv else if gap-x then vh else hv.min(vh)

fun next-cost-matrix(prev: cost-matrix): cost-matrix
    vector-init(5) fn(i)
        vector-init(5) fn(j)
            move-cost(from = index-dir(i), to = index-dir(j), ?pad = directional, ?costs = prev)

fun calculate-num-cost(num: string, pad: pad, ?costs: cost-matrix): int
    num.list.foldl((0, 'A'), fn ((acc, prev), c) (acc + move-cost(prev, c), c)).fst

fun cost-matrix-degree(?degree: int): cost-matrix
    list(1, degree).foldl(initial-cost-matrix, fn(prev, _) next-cost-matrix(prev))

fun solve(?degree: int): <input, io> int
    val ?costs = cost-matrix-degree()
    sequences().map fn(num) 
        val cost = calculate-num-cost(num, numeric)
        val d = num.replace-all("A", "").parse-int().default(0)
        println((num, cost, d))
        cost * d
    .sum



pub fun main()
    with input-full
    println(solve(2))
    println(solve(25))