module advent/day20

import advent/input
import odo/queue
import odo/maybe
import std/data/hashmap


alias racetrack = vector<vector<char>>
alias pos = vector<int>
fun read-racetrack()
    read-input(20).split("\n").map(vector).vector

fun neighbors(x: int, y: int, ?dim: int): list<(int, int)>
    [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)].filter fn((i, j)) 
        i >= 0 && j >= 0 && i < dim && j < dim

fun for-neighbors(x: int, y: int, f: (int, int, int) -> e (), dist: int, ?dim: int): e ()
    fun neighbor(a, b, ?d) if a >= 0 && b >= 0 && a < dim && b < dim then f(a, b, d)

    for(dist) fn(t)
        val d = t + 1
        for(d) fn(i)
            val j = d - i
            neighbor(x + i, y + j)
            neighbor(x + j, y - i)
            neighbor(x - i, y - j)
            neighbor(x - j, y + i)
                


fun cheats(rt: racetrack, ?max-dist: int)
    val dim = rt.length
    var d := vector(dim * dim, 1_000_000_000)
    var late := vector(dim * dim, 0)
    var q := queue([])
    var last-mut := 0
    foreach-indexed(rt) fn(i, v)
        foreach-indexed(v) fn(j, c)
            if c == 'S' then
                d[i * dim + j] := 0
                q := q.enqueue((i, j, 0))

    while-just(fn () q.dequeue()) fn (((x, y, w), q'))
        q := q'
        last-mut := w
        for-neighbors(x, y, dist = 1) fn (i, j, _)
            val k = i * dim + j
            if d[k] > w + 1 then d[k] := w + 1 else return ()
            if rt[i][j] != '#' then q := q.enqueue((i, j, w + 1))
    
    val last = last-mut
    var results := vector(last, 0) 
    var seen := vector(dim * dim, False)
    fun seek(x, y, rest)
        val k = x * dim + y
        if seen[k] then return ()
        seen[k] := True
        for-neighbors(x, y, dist = rest) fn(i, j, u)
            if rt[i][j] == '#' then seek(i, j, rest - u)
        seen[k] := False
    foreach-indexed(rt) fn(i, v)
        foreach-indexed(v) fn(j, c)
            if c == '#' then return ()
            val begin = d[i * dim + j]
            for-neighbors(i, j, dist = max-dist) fn(x, y, u)
                if rt[x][y] == '#' then return()
                val finish = d[x * dim + y]
                val dif = finish - begin - u    

                if dif > 0 then results[dif] := results[dif] + 1

    results.list.map-indexed(fn (i, v) if v > 0 then [(i, v)] else []).flatmap(id)


fun solve(?max-dist: int)
    val rt = read-racetrack()
    val x = rt.cheats()
    println(x.filter-map(fn ((i, v)) whether(i >= 100){v}).sum)

    
pub fun main()
    with input-full
    solve(?max-dist = 2)
    solve(?max-dist = 20)