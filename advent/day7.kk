module advent/day7

import advent/input

fun search(nums: list<int>, cur: int, ?target: int): bool 
   match nums 
    Nil -> cur == target
    Cons(x, xs) -> xs.search(cur + x) || xs.search(cur * x)


fun part1()
    val lines = read-input(7)
        .split("\n")
        .map fn (l)
            val [h, t] = l.split(": ")
            val target = h.parse-int().default(0)
            (target, t.split(" ").map(fn (x) x.parse-int().default(0)))
    val good = lines.filter-map fn ((t, nums))
        if nums.search(0, t) then Just(t) else Nothing

    println(lines)
    println(good)
    println(good.sum)

pub fun main()
    with input-full
    part1()
    
   