module advent/day18

import advent/input
import odo/list
import odo/queue

fun read-pairs() read-input(18).split("\n").map fn(l) 
    l.split(",").filter-map(fn(x) x.parse-int).list-pair

fun solve(limit)
    val pairs = read-pairs()
    val dim = map-size()
    var m := vector(dim * dim, False)
    foreach(pairs.take(limit)) fn ((x, y)) m[x * dim + y] := True
    var q := queue([(0, 0, 0)])
    fun go() match q.dequeue()
        Nothing -> Nothing
        Just(((x, y, s), q')) -> 
            q := q'
            if x == dim - 1 && y ==  dim - 1 then Just(s)
            else 
                foreach([(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]) fn ((x', y'))
                    if x' >= 0 && x' < dim && y' >= 0 && y' < dim && !m[x' * dim + y'] then 
                        q := q.enqueue((x', y', s + 1))
                        m[x' * dim + y'] := True
                go()
    go()

fun part1() 
    solve(match input()
        Sample -> 12
        Full -> 1024
    )

fun part2()
    val ps = read-pairs()
    val n = ps.length
    for-while(1, n) fn(lim)
        if solve(lim).is-nothing() then ps[lim - 1] else Nothing

fun map-size() match input()
    Sample -> 7
    Full -> 71

fun fall-limit() match input()
    Sample -> 12
    Full -> 1024


effect union-find
    fun uf-get(i: int): int
    fun uf-set(i: int, v: int): unit

fun parent(i): <union-find, div> int
    var p := parent
    fun go(j) match uf-get(j)
        x | x <= 0 -> 
            val res = go(~x)
            uf-set(i, ~res)
            res
        _ -> j
    go(i)

fun merge(i, j): _ unit
    val pi = parent(i)
    val pj = parent(j)
    if pi != pj then 
        val si = uf-get(pi)
        val sj = uf-get(pj)
        val (a, b) = if si <= sj then (pi, pj) else (pj, pi)
        uf-set(a, si + sj + 1)
        uf-set(b, ~a)

fun run-union-find(n, f : () -> <union-find, exn | e> x): <exn|e> x
    var uf := vector(n, 1)
    with handler
        fun uf-get(i) uf[i]
        fun uf-set(i, v) uf[i] := v
    f()

fun part2'(): _ maybe<(int, int)>
    val ps = read-pairs()
    val n = map-size()
    val (upright, downleft) = (n * n , n * n + 1)
    var m := vector(n * n, False)
    run-union-find(n * n + 2)
        find(ps) fn((x, y))
            val k = x * n + y
            if x == 0 || y == n - 1 then merge(k, downleft)
            if y == 0 || x == n - 1 then merge(k, upright)
            for(-1, 1) fn(dx) for(-1, 1) fn(dy)
                val (x', y') = (x + dx, y + dy)
                if x' >= 0 && x' < n && y' >= 0 && y' < n && m[x' * n + y'] then merge(k, x' * n + y')
            m[k] := True
            parent(upright) == parent(downleft)     

pub fun main()
    with input-full
    println(part2'())