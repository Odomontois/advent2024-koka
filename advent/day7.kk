module advent/day7

import advent/input
import std/core/undiv

fun search(nums: list<(int, int)>, cur: int, ?target: int): bool 
    cur <= target && (
    match nums 
        Nil -> cur == target
        Cons((x, _), xs) -> xs.search(cur + x) || 
                            xs.search(cur * x)
    )

fun log10(x: int, acc: int = 1): int
    if x == 0 then acc else ((x / 10).pretend-decreasing).log10(acc * 10)

fun search2(nums: list<(int, int)>, cur: int, ?target: int): bool 
    cur <= target && (
    match nums 
        Nil -> cur == target
        Cons((x, p10), xs) -> xs.search2(cur + x) || 
                              xs.search2(cur * x) || 
                              xs.search2(cur * p10 + x)
    )

fun input7()
    read-input(7)
    .split("\n")
    .map fn (l)
        val [h, t] = l.split(": ")
        val target = h.parse-int().default(0)
        val nums = t.split(" ").map fn (x) 
                        val xx = x.parse-int().default(0)
                        (xx, xx.log10)
        (target, nums)

fun part1()
    val lines = input7()
    val good = lines.filter-map fn ((t, nums))
        if nums.search(0, t) then Just(t) else Nothing

    println(lines)
    println(good)
    println(good.sum)

fun part2()
    val lines = input7()
    val good = lines.filter-map fn ((t, nums))
        if nums.search2(0, t) then Just(t) else Nothing
    println(good.sum)

pub fun main()
    with input-full
    part2()
    
   