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

fun neighbors2(x: int, y: int, ?dim: int): list<(int, int)>
    [(0, 2), (1, 1)].flatmap fn((da, db))
        [(x + da, y + db), (x + db, y - da), (x - da, y - db), (x - db, y + db)].filter fn((i, j))
            i >= 0 && j >= 0 && i < dim && j < dim


fun cheats(rt: racetrack)
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
        foreach(neighbors(x, y)) fn((i, j))
            val k = i * dim + j
            if rt[i][j] == '#' && d[k] > w + 1 then d[k] := w + 1
            if d[k] <= w + 1 || rt[i][j] == '#' then return ()
            d[k] := w + 1
            q := q.enqueue((i, j, w + 1))
            ()
    
    val last = last-mut
    var results := vector(last, 0) 
    foreach-indexed(rt) fn(i, v)
        foreach-indexed(v) fn(j, c)
            if c != '#' then return()
            val begin = d[i * dim + j]
            foreach(neighbors(i, j)) fn((x, y))
                if rt[x][y] == '#' then return()
                val finish = d[x * dim + y]
                val dif = finish - begin - 1    
                if dif > 0 then results[dif] := results[dif] + 1

    results.list.map-indexed(fn (i, v) if v > 0 then [(i, v)] else []).flatmap(id)


fun part1()
    val rt = read-racetrack()
    rt.cheats()

    
pub fun main()
  with input-full
  part1().filter-map(fn ((i, v)) whether(i >= 100){v}).sum
  .println