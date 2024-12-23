module advent/day23

import advent/input

import odo/list

fun read-graph()
    read-input(23).split("\n").map fn(s)
        val [l, r] = s.split("-")
        (l, r)
alias graph = vector<list<int>>

val a-code = 'a'.int
fun letter(i: int) (i + a-code).char
fun code(s: string) s.list.foldl(0) fn(acc, c) acc * 26 + c.int - a-code
fun name(i: int) string([letter(i / 26) , letter(i % 26)])

fun make-graph(pairs: list<(string, string)>): pure graph
    var vertices := vector(676, Nil)
    fun connect(x, y) vertices[x] := Cons(y, vertices[x])
    foreach(pairs) fn((a, b))
        val ai = code(a)
        val bi = code(b)
        connect(ai, bi)
        connect(bi, ai)
    for(676) fn(i)
        val v = vertices[i]
        vertices[i] := vertices[i].merge-sort
    
    vertices

fun part1()
    val graph = read-graph().make-graph
    val (ta, tz) = (code("ta"), code("tz"))
    graph.cliques1.progress.progress.filter(fn(Clique(vs)) vs.any fn(v) v >= ta && v <= tz).length

value struct clique
    vertices: list<int>
    connected: list<int>

fun cliques1(g: graph): pure list<clique>
    g.list.map-indexed fn (i, v) Clique([i], v)

fun progress(cs: list<clique>, ?graph: graph): pure list<clique>
    cs.flatmap fn(c)
        val head = c.vertices.head(0)
        c.connected.filter(fn (i) i < head).map fn(j)
            Clique(Cons(j, c.vertices), graph[j].intersect(c.connected)) 

fun part2()
    val graph = read-graph().make-graph
    fun go(cs) match cs.progress
        [Clique(vertices)] -> vertices.map(name).join(",")
        cs' -> go(cs')
    graph.cliques1().go()

pub fun main()
    with input-full
    part2()