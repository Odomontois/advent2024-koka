module advent/day11

import advent/input
import odo/list
import std/data/hashset
import std/data/hashmap
import std/data/hash
import std/core/undiv

val ?hash: (int, int64) -> int = int/hash

fun stones() 
    read-input(11).split(" ").filter-map fn(x) x.parse-int

fun count(x, ticks)
    if ticks == 0 then return 1
    if x == 0 then return count(1, ticks - 1)
    val d = x.count-digits()
    if d % 2 == 1 then return count(x * 2024, ticks - 1)
    val (a, b) = x.divmod-exp10(d / 2)
    count(a, ticks - 1) + count(b, ticks - 1)


rec effect cache
    fun read-cache(k: int): maybe<int>
    fun write-cache(k: int, v: int): unit

fun count-rocks(x: int, ticks: int): <cache, div> int
        if ticks == 0 then return 1
        val code = x * 100 + ticks
        match read-cache(code)
            Just(v) -> return v
            Nothing -> ()
        val res =  if x == 0 then count-rocks(1, ticks - 1) else 
            val d = x.count-digits()
            if d % 2 == 1 then return count-rocks(x * 2024, ticks - 1)
            val (a, b) = x.divmod-exp10(d / 2)
            count-rocks(a, ticks - 1) + count-rocks(b, ticks - 1)
        write-cache(code, res)
        res
            

fun with-hash-cache<r>(block: () -> <cache|e> r): e r
    var cache := thread/hash-map()
    with handler
        fun read-cache(k) cache.get(k)
        fun write-cache(k, v) 
            cache := cache.insert(k, v)
            ()
    block()    
        

fun solve(size)
    with-hash-cache
        stones().map(fn (x) count(x, size)).sum

fun part1() solve(25)

fun part2() solve(75)

pub fun main()
    with input-full
    part2()
    