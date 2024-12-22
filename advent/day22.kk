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
fun process(x, n) if n == 0 then x else process(x.step, n - 1)

    

pub fun main()
    with input-full
    read-nums().map(fn(x) process(x.int64, 2000)).map(int).sum
