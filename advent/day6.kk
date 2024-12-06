module advent/day6


import advent/input
import odo/list
import odo/string

struct lab
   start: (int, int)
   size: (int, int)
   rows: list<string>
   obst-vec: vector<vector<bool>>

fun show(Lab(start, rows)): string
    "Lab( " ++ start.show() ++ ", " ++ rows.show() ++ " )"

fun read-lab()
    val lines = read-input(6).split("\n")
    val start = lines.find-indexed-maybe fn (i, x)
                    x.index-of('^').map(fn(j) (i, j))
                .default((0, 0))
    val n = lines.length
    val m = lines[0].default("").count()
    val obst-vec = lines.vector().map fn(l) l.vector().map(fn(c) c == '#')
                   
    Lab(start, (n, m), lines, obst-vec)

fun visit-points(Lab((sx, sy), (n, m), _, obst))
    val dirs = [(0, 1), (1, 0), (0, -1), (-1, 0)].vector()
    run
        val visited = vector-init(n, fn (_) vector-init(m, fn (_) ref(False)))
        fun go(x, y, dir)
            val (dx, dy) = dirs[dir]
            val nx = x + dx
            val ny = y + dy
            if nx < 0 || nx >= n || ny < 0 || ny >= m then return ()
            if obst[nx][ny] then go(x, y, (dir + 1) % 4)
            else
                visited[nx][ny].set(True)
                go(nx, ny, dir)
        try
           visited[sx][sy].set(True)
           go(sx, sy, 3)
        .default(())

        visited.map(fn (row) row.map(fn (r) !r))
   
fun combine(rows: list<string>, visited: vector<vector<bool>>)
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
    val v = visit-points(lab)
    val n = v.list().map(fn(l) l.list().map(fn (x) if x then 1 else 0).sum()).sum()
    println(combine(lab.rows, v))
    println(n)
    ()
pub fun main()
  with input-full
  part1()
