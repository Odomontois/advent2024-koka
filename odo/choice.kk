module odo/choice

import std/core/undiv

pub effect ctl choice(): bool

pub fun branch(first: a, rest: list<a>): choice a match rest
    Nil -> first
    Cons(second, rest') -> if choice() then first else branch(second, rest')

pub fun choice/fold(expr: () -> <choice| e> b, f: (b, b) -> b): e b
    with ctl choice() f(resume(False), resume(True))
    expr()

effect state<a>
    fun get(): a
    fun put(s: a): ()

fun run-state(s: a, expr: () -> <state<a> | e> b): e b
    var cur := s
    with handler
        fun get() pretend-no-div(fn() cur)
        fun put(new) cur := new
    expr()

fun foldl-int(expr: () -> <state<b>, choice| e> a, f: (a, b) -> <choice, state<b> | e> b): <state<b> |e> ()
    with handler ctl choice() 
        resume(False)
        resume(True)
    put(f(expr(), get()))

// pub fun search/foldl(expr: () -> <choice | e> a, init: b, f: (a, b) -> <choice| e> b): e b
//     run-state(init)
//         foldl-int(fn () expr(), f)
//         get()

