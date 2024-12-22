module advent/day22


import advent/input
import std/num/int64

fun read-nums()
    read-input(22).split("\n").filter-map(fn(s) s.parse-int)

val prune-mod = 16777216.int64

fun prune(x) x.cmod(prune-mod)
fun mix(x, y) x.xor(y).prune

fun stage1(x) x.xor(x.shl(6)).prune
fun stage2(x) x.xor(x.shr(5)).prune
fun stage3(x) x.xor(x.shl(11)).prune

fun step(x) x.stage1.stage2.stage3
fun process(x, n) if n == 0 then x else x.step.process(n - 1)

fun part1()   
    read-nums().map(fn(x) process(x.int64, 2000)).map(int).sum

val ten = 10.int64
val twenty = 20.int64

fun key(d1, d2, d3, d4) d4 + 20 * (d3 + 20 * (d2 + 20 * d1))

fun part2()
    val nums = read-nums().map(int64)
    var sums := vector(20.pow(4), 0)
    var seen := vector(20.pow(4), -1)
    
    fun analyze(i: int, x, d1, d2, d3, p4, n)
        if n == 2000 return ()
        val x' = x.step
        val p5 = x'.int % 10
        val d4 = p5 - p4 + 10
        val k = key(d1, d2, d3, d4)
        if n > 2 then
            if seen[k] < i then
                seen[k] := i
                sums[k] := sums[k] + p5
        analyze(i, x', d2, d3, d4, p5, n.inc)
        
    foreach-indexed(nums) fn(i, num)
        analyze(i, num, -1, -1, -1, num.int % 10, 0)
    var best := 0
    var k := 0
    foreach-indexed(sums) fn(i, s)
        if best < s then
            best := s
            k := i
    println(best)


pub fun main()
    with input-full
    part2()
    
