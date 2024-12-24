module advent/day24

import advent/input
import std/data/hashmap
import odo/list

type op
    And
    Xor
    Or

fun op/show(op) match op
    And -> "AND"
    Xor -> "XOR"
    Or -> "OR"

struct rule<k>
    first: k
    second: k
    op: op
    result: k

fun rule/show(r: rule<k>, ?key/show: k -> string) 
    r.first.show ++ " " ++ 
    r.op.show ++ " " ++ 
    r.second.show ++ " -> " ++ 
    r.result.show

fun rule/map(r: rule<a>, f: (a) -> e b): e rule<b>
    Rule(f(r.first), f(r.second), r.op, f(r.result))

value struct logic<k>
    initial: list<(k, int)>
    produce: list<rule<k>>

fun logic/map(l: logic<a>, f: (a) -> e b): e logic<b>
    Logic(l.initial.map(fn((k, v)) (f(k), v)), l.produce.map(fn(r) r.map(f)))

fun logic/show(l: logic<k>, ?key/show: k -> string)
    (l.initial.map(fn ((k, v)) k.show ++ ": " ++ v.show) ++ l.produce.map(fn(r) r.show))
    .join("\n")

pub fun parse-rule-string()
    val [ins, pros] = read-input(24).split("\n\n").map(fn(s) s.split("\n"))
    val initial = ins.map fn(s)
        val [k, v] = s.split(": ")
        (k, v.parse-int().default(-1))
    val produce = pros.map fn(s)
        val [l, r] = s.split(" -> ")
        val [f, o, s] = l.split(" ")
        val op = match o
            "AND" -> And
            "XOR" -> Xor
            "OR" -> Or
        Rule(f, s, op, r)
    Logic(initial, produce)

pub fun parse-rule-int()
    val logic-string = parse-rule-string()
    val keys = logic-string.enumerate-keys
    logic-string.map(fn(k) keys.bin-lookup(k).default(-1))

pub fun enumerate-keys(logic: logic<k>, ^?cmp: (k, k) -> order): vector<(k, int)>
    val keys = logic.initial.map(fst) ++ 
               logic.produce.flatmap(fn(r) [r.first, r.second, r.result])
    keys.merge-sort.dedup.map-indexed(fn(i, k) (k, i)).vector

fun bin-lookup(xs: vector<(a, b)>, k: a, ^?cmp: (a, a) -> order): pure maybe<b>
    fun go(lo: int, hi: int)
        if lo > hi then Nothing
        else
            val mid = (lo + hi) / 2
            match xs[mid].fst.cmp(k)
                Lt -> go(mid + 1, hi)
                Eq -> Just(xs[mid].snd)
                Gt -> go(lo, mid - 1)
    go(0, xs.length - 1)



pub fun main()
    with input-sample
    parse-rule-int()