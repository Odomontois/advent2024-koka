module advent/day6


import advent/input
import odo/list
import odo/string

import std/num/int32

struct lab
   start: (int, int)
   size: (int, int)
   rows: list<string>
   obst-vec: vector<bool>

fun show(^Lab(start, rows)): string
    "Lab( " ++ start.show() ++ ", " ++ rows.show() ++ " )"

fun read-lab()
    val lines = read-input(6).split("\n")
    val start = lines.find-indexed-maybe fn (i, x)
                    x.index-of('^').map(fn(j) (i, j))
                .default((0, 0))
    val n = lines.length
    val m = lines[0].default("").count()
    val obst-vec = vector(lines.flatmap fn(l) l.list().map(fn(c) c == '#'))
                   
    Lab(start, (n, m), lines, obst-vec)


fun traverse-lab(^Lab((sx, sy), (n, m), _, obst), ^ret: bool = True)
    var visited := vector(n * m, zero)
    fun go(x, y, dx: int, dy: int, dir)
        val nx = x + dx
        val ny = y + dy
        if nx < 0 || nx >= n || ny < 0 || ny >= m then return True
        if obst[nx * m + ny] then go(x, y, ~dy, ~dx, (dir + 1) % 4)
        else
            val v = visited[nx * m + ny]
            val d = one.shl(dir)
            if v.and(d) != zero then return False
            visited[nx * m + ny] := v.or(d)
            go(nx, ny, dx, dy, dir)
    visited[sx * m + sy] := one
    val exited = go(sx, sy, -1, 0, 0)
    val vis = if !ret then unit/vector() else 
        vector-init(n) fn (i) vector-init(m) fn(j) visited[i * m + j] != zero
    (exited, vis)

 
fun combine(^rows: list<string>, ^visited: vector<vector<bool>>)
    rows
        .zipwith(visited.list()) fn(row, vr)
            row.list()
            .zipwith(vr.list()) fn (c, v) 
                if v then '@' else c
            .string()
        .join-end("\n")

fun part1()
    val lab = read-lab()
    println(lab)
    val (_, v) = traverse-lab(lab)
    val n = v.list().map(fn(l) l.list().map(fn (x) if x then 1 else 0).sum()).sum()
    println(combine(lab.rows, v))
    println(n)
    ()

fun part2()
    val lab as Lab(start = (sx, sy), size = (n, m)) = read-lab()
    val (_, v) = traverse-lab(lab)
    val count = 
        var ovm := lab.obst-vec
        var count := 0
        for(0, n - 1) fn(i) 
            for(0, m - 1) fn(j)
                if v[i][j] && !(sx == i && sy == j) then
                    ovm[i * m + j] := True
                    val (exited, _)  = traverse-lab(lab(obst-vec = ovm), False)
                    ovm[i * m + j] := False
                    if !exited then count := count + 1
        count
    println(count)

    ()
pub fun main()
  println(one.shl(0))
  with input-full
  part2()


fun check()
    var x := vector(5, 0)
    x[0] := 1
    x[1] := 2
    x

fun check2() 
    var x := vector(5, vector(5, 0))
    var x0 := x[0]
    x[0] := unit/vector()
    x0[0] := 1
    x[0] := x0
    x
