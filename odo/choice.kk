module odo/choice

pub effect ctl choice(): bool

pub fun choice/fold(expr: () -> <choice| e> b, f: (b, b) -> b): e b
    with ctl choice() 
        f(resume(False), resume(True))
    expr()

// pub fun search/foldl(expr: () -> <choice| e> b, init: b, f: (a, b) -> b): e b
//     with ctl choice()
//         val next = resume(False)
//         search/foldl(fn () resume(True), next, f)
//     expr()

// pub fun main()
//     fun lol(n, p) if p == 0 then n else lol(if !choice() then 2 * n else 2 * n + 1, p - 1)
//     search/fold(fn() lol(0, 25), (+))
