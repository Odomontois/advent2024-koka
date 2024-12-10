module advent/day10

import advent/input
import odo/list

pub fun read-map() read-input(10).split("\n").vector().map fn(x) x.vector()
pub fun part1()
    val tm = read-map()
    val n = tm.length
    println(tm.list.foldl(0) fn(s, x) x.list.foldl(s) fn (s, x) if x == '9' then s + 1 else s)
    var score := vector(n * n, Nil)
    var total := 0
    for(10) fn(u)
        val c = ('9'.int - u).char
        val c1 = ('9'.int - u + 1).char
        for(n) fn(i)
            for(n) fn(j)
                if tm[i][j] != c return ()
                val k = i * n + j
                val s = if u == 0 then [k] else 
                    val neighbors = [(i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1)]
                    neighbors.foldl([]) fn(s, (x, y))
                        if x >= 0 && x < n && y >= 0 && y < n && tm[x][y] == c1 
                        then s.union(score[x * n + y])
                        else s
                score[i * n + j] := s
                if u == 9 then total := total + s.length
    println(total)
    // list(0, n - 1).map fn(i)
    //     list(0, n - 1).map fn(j)
    //         score[i * n + j]
               
                


pub fun main()
    with input-full
    part1()