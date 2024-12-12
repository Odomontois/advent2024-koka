module advent/day12

import advent/input
import odo/list
import odo/queue

fun walk-garden(garden: vector<vector<char>>)
    val n = garden.length
    var seen := vector(n * n, False)
    var area := 0
    var perimeter := 0
    var q := queue/empty()
    var total := 0
    for(n) fn(i) for(n) fn(j) 
        if seen[i * n + j] then () else 
            area := 1
            perimeter := 0
            q := queue([(i, j)])
            val that = garden[i][j]
            seen[i * n + j] := True
            fun go() match q.dequeue
                Nothing -> area * perimeter
                Just(((x, y), q')) -> 
                    q := q'
                    foreach([(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]) fn((x', y'))
                        if x' < 0 || x' >= n || y' < 0 || y' >= n || garden[x'][y'] != that  
                        then perimeter := perimeter + 1
                        else if seen[x' * n + y'] then ()
                        else 
                            seen[x' * n + y'] := True
                            area := area + 1
                            q := q.enqueue((x', y'))
                    go()
            total := total + go()
    total

fun read-garden()
    read-input(12).split("\n").vector.map fn(x) x.vector

fun part1()
    read-garden().walk-garden()

pub fun main()
    with input-full
    part1()