module advent/day16

import advent/input
import odo/list

alias race-map = vector<vector<char>>

fun read-map() read-input(16).split("\n").map(vector).vector

fun start(m: race-map): (int, int)
    with handler final ctl throw-exn(e) (-1, -1)
    for-while(m.length) fn(i)
        for-while(m.length) fn (j)
            if m[i][j] == 'S' then Just((i, j)) else Nothing
    .unjust

struct item
    x: int
    y: int
    dir: int
    cost: int

fun cmp(i1, i2): order 
    i1.cost.cmp(i2.cost)

fun solve(m: race-map)
    val dim = m.length
    val (sx, sy) = start(m)
    var best := vector(dim * dim * 4, 1000_000_000)
    val dirs = vector([(-1, 0), (1, 0), (0, -1), (0, 1)])
    fun go(q) match q
        Nil -> Nothing
        Cons(Item(x, y, d, s), q') -> 
            val u = m[x][y]
            if u == 'E' then return Just(s)
            if best[x * dim * 4 + y * 4 + d] < s then return go(q')
            val neighbors = list(0, 3).filter-map fn(d')
                val (dx, dy) = dirs[d']
                val (x', y') = (x + dx, y + dy)
                if x' < 0 || x' >= dim || y' < 0 || y' >= dim || m[x'][y'] == '#' then return Nothing
                val cur = best[x' * dim * 4 + y' * 4 + d]
                val s' = s + (if d' == d then 1 else 1001)
                if best[x * dim * 4 + y * 4 + d'] <= s' then return Nothing
                best[x * dim * 4 + y * 4 + d] := s'
                Just(Item(x', y', d', s'))
            val q'' = neighbors.foldl(q') fn (qp, t) qp.insert(t)
            go(q'')
    
    val res = go([Item(sx, sy, dir = 3, cost = 0)])
    res

fun part1()
    val ip = read-map()
    // ip.foreach fn(s) println(s.string)
    println(ip.start)
    println(solve(ip))

pub fun main()
    with input-full 
    part1()
