module advent/day23

import advent/input

import odo/list

fun read-graph()
    read-input(23).split("\n").map fn(s)
        val [l, r] = s.split("-")
        (l, r)

value struct graph-item
    name: string
    connected: list<int>

value struct graph
    vertices: vector<graph-item>
    connected: (int, int) -> bool

val a-code = 'a'.int
fun letter(i: int) (i + a-code).char
fun code(s: string) s.list.foldl(0) fn(acc, c) acc * 26 + c.int - a-code
fun name(i: int) string([letter(i / 26) , letter(i % 26)])

fun make-graph(pairs: list<(string, string)>): pure graph
    var vertices := vector-init(676) fn(i) Graph-item(name(i), Nil)
    var connections := vector(26.pow(4), False)
    fun connect(x, y)
        val v = vertices[x]
        vertices[x] := v(connected = Cons(y, v.connected))
        connections[x * 676 + y] := True
    foreach(pairs) fn((a, b))
        val ai = code(a)
        val bi = code(b)
        connect(ai, bi)
        connect(bi, ai)
    val connects = connections
    for(676) fn(i)
        val v = vertices[i]
        vertices[i] := vertices[i](connected = v.connected.merge-sort)
    
    Graph(vertices, fn(a, b) connects.at(a * 676 + b) == Just(True))

fun part1()
    val g = read-graph().make-graph
    val (ta, tz) = (code("ta"), code("tz"))
    var res := 0
    for(ta, tz) fn(i)
        val v = g.vertices[i]
        map-peek(v.connected) fn(j, rest)
            if j < i && j >= ta then return ()
            foreach(rest) fn (k)
                if k < i && k >= ta then return ()
                if !(g.connected()(j, k)) then return ()
                println([name(i), name(j), name(k)])
                res := res + 1
        .ignore 
    res

value struct clique
    vertices: list<int>
    connected: list<int>

fun cliques1(g: graph): pure list<clique>
    g.vertices.list.map-indexed fn (i, v) Clique([i], v.connected)

fun progress(g: graph, cs: list<clique>): pure list<clique>
    cs.flatmap fn(c)
        val head = c.vertices.head(0)
        c.connected.filter(fn (i) i < head).map fn(j)
            Clique(Cons(j, c.vertices), g.vertices[j].connected.intersect(c.connected))

fun part2()
    val g = read-graph().make-graph
    fun go(cs)
        match g.progress(cs)
            [Clique(vertices)] -> vertices.map(name).join(",")
            cs' -> go(cs')
    g.cliques1().go()

pub fun main()
    with input-full
    part2()