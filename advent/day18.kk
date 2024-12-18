module advent/day18

import advent/input
import odo/list
import odo/queue

fun read-pairs() read-input(18).split("\n").map fn(l) 
    l.split(",").filter-map(fn(x) x.parse-int).list-pair

fun part1()
    val pairs = read-pairs()
    val dim = map-size()
    var m := vector(dim * dim, False)
    foreach(pairs.take(fall-limit())) fn ((x, y)) m[x * dim + y] := True
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

fun map-size() match input()
    Sample -> 7
    Full -> 71

fun fall-limit() match input()
    Sample -> 12
    Full -> 1024

pub fun main()
    with input-full
    part1()