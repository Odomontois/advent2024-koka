module advent/day12

import advent/input
import odo/list
import odo/queue

fun walk-garden(garden: vector<vector<char>>)
    val n = garden.length
    var seen := vector(n * n, False)
    var seen-sides := vector(n * n * 4, False)
    var area := 0
    var perimeter := 0
    var sides := 0
    var q := queue/empty()
    var total1 := 0
    var total2 := 0
    for(n) fn(i) for(n) fn(j) 
        if seen[i * n + j] then () else 
            area := 1
            perimeter := 0
            sides := 0
            q := queue([(i, j)])
            val that = garden[i][j]
            seen[i * n + j] := True
            fun check-side(x, y, side)
                perimeter := perimeter + 1
                seen-sides[x * n * 4 + y * 4 + side] := True
                fun check (x', y')
                    x' < 0 || x' >= n || y' < 0 || y' >= n ||
                    garden[x'][y'] != that  || 
                    !seen-sides[x'*n*4+y'*4+side]

                val res = if side < 2 
                    then check(x, y - 1) && check(x, y + 1) 
                    else check(x - 1, y) && check (x + 1, y)

                if res then sides := sides + 1
            fun go() match q.dequeue
                Nothing -> (area * perimeter, area * sides)
                Just(((x, y), q')) -> 
                    q := q'
                    foreach([(x - 1, y, 0), (x + 1, y, 1), (x, y - 1, 2), (x, y + 1, 3)]) fn((x', y', side))
                        if x' < 0 || x' >= n || y' < 0 || y' >= n || garden[x'][y'] != that  
                        then check-side(x, y, side)
                        else if !seen[x' * n + y'] 
                        then 
                            seen[x' * n + y'] := True
                            area := area + 1
                            q := q.enqueue((x', y'))
                    go()
            val (p1, p2) = go()
            // println(
            //     "letter: " ++ that.string ++ 
            //     ", area: " ++ area.show ++ 
            //     ", perimeter: " ++ perimeter.show ++ 
            //     ", sides: " ++ sides.show ++
            //     ", p1: " ++ p1.show ++
            //     ", p2: " ++ p2.show
            // )
            total1 := total1 + p1
            total2 := total2 + p2
    (total1, total2)

fun read-garden()
    read-input(12).split("\n").vector.map fn(x) x.vector

fun solve()
    read-garden().walk-garden()

pub fun main()
    with input-full
    solve()