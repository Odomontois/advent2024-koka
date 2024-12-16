module advent/day16

import advent/input
import odo/list
import odo/queue

alias race-map = vector<vector<char>>

fun read-map() read-input(16).split("\n").map(vector).vector

fun find(m: race-map, sym): (int, int)
    with handler final ctl throw-exn(e) (-1, -1)
    for-while(m.length) fn(i)
        for-while(m.length) fn (j)
            if m[i][j] == sym then Just((i, j)) else Nothing
    .unjust

struct item
    x: int
    y: int
    dir: int
    cost: int

fun key(Item(x, y, d, _), ?dim: int): total int 
    x * dim * 4 + y * 4 + d

fun small-key(Item(x, y, _, _), ?dim: int): total int 
    x * dim + y

fun cmp(i1, i2): order 
    i1.cost.cmp(i2.cost)

fun direct(d) match d
    0 -> (-1, 0)
    1 -> (1, 0)
    2 -> (0, -1)
    3 -> (0, 1)
    _ -> (0, 0)

fun solve(m: race-map)
    val dim = m.length
    val (sx, sy) = find(m, 'S')
    val (ex, ey) = find(m, 'E')
    var best := vector(dim * dim * 4, 100_000_000)
    var prev := vector(dim * dim * 4, Nil)
    var seen := vector(dim * dim, False)
    var end-cost := 100_000_000

    fun go(q: list<item>) match q
        Nil -> Nothing
        Cons(i as Item(x, y, d, s), q') -> 
            val u = m[x][y]
            if u == 'E' then end-cost := end-cost.min(s)
            val k = i.key
            if best[k] < s then return go(q')
            val neighbors = list(0, 3).filter-map fn(d')
                val (dx, dy) = direct(d')
                val (x', y') = (x + dx, y + dy)
                if x' < 0 || x' >= dim || y' < 0 || y' >= dim || m[x'][y'] == '#' then return Nothing
                val s' = s + (if d' == d then 1 else 1001)
                val i' = Item(x', y', d', s')
                val k' = i'.key
                match best[k'].cmp(s') 
                    Lt -> Nothing
                    Eq -> 
                        prev[k'] := Cons(i, prev[k'])
                        Nothing
                    Gt ->
                        prev[k'] := [i]
                        best[k'] := s'
                        Just(i')
            val q'' = neighbors.foldl(q') fn (qp, t) qp.insert(t)
            go(q'')

    fun go-back(q: queue<item>, acc = 0) match q.dequeue
        Nothing -> acc
        Just((i, q')) -> 
            val (k, ks) = (i.key, i.small-key)
            val prevs = prev[k]
            prev[k] := Nil
            val add = !seen[ks]
            seen[ks] := True
            val q'' = prevs.foldl(q') fn (qp, t) qp.enqueue(t)
            go-back(q'', acc + add.int)

    go([Item(sx, sy, dir = 3, cost = 0)])
    val ends = list(0, 3).map(fn(d) Item(ex, ey, d, 0)).filter(fn(i) best[i.key] == end-cost)
    val count = go-back(queue(ends))

    (end-cost, count)

fun part1()
    val ip = read-map()
    println(solve(ip))

pub fun main()
    with input-full
    part1()
