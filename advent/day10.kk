module advent/day10

import advent/input
import odo/list

pub fun read-map() read-input(10).split("\n").vector().map fn(x) x.vector()

pub fun count(tm: vector<vector<char>>, single: int -> a, empty: a, combine: (a, a) -> a, res: a -> int): _ int
    val n = tm.length
    var score := vector(n * n, empty)
    var total := 0
    for(10) fn(u)
        val c = ('9'.int - u).char
        val c1 = ('9'.int - u + 1).char
        for(n) fn(i)
            for(n) fn(j)
                if tm[i][j] != c return ()
                val k = i * n + j
                val s = if u == 0 then single(k) else 
                    val neighbors = [(i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1)]
                    neighbors.foldl(empty) fn(s, (x, y))
                        if x >= 0 && x < n && y >= 0 && y < n && tm[x][y] == c1 
                        then s.combine(score[x * n + y])
                        else s
                score[i * n + j] := s
                if u == 9 then total := total + res(s)
    total

fun part1()
    read-map().count(fn (x) [x], [], fn(x, y) x.union(y), length)

fun part2()
    read-map().count(fn (_) 1, 0, (+), fn(x) x)
               
                


pub fun main()
    with input-full
    part2()