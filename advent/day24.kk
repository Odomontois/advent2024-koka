module advent/day24

import advent/input
import odo/list
import std/num/int32

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
    (   l.initial.map(fn ((k, v)) k.show ++ ": " ++ v.show) ++ 
        l.produce.map(fn(r) r.show))
    .join("\n")

pub fun parse-rule-string()
    val [ins, pros] = read-input(24).split("\n\n").map(fn(s) s.split("\n"))
    val initial = ins.map fn(s)
        val [k, v] = s.split(": ")
        (k, v.parse-int().default(-1))
    val produce = pros.map fn(s)
        val [l, r] = s.split(" -> ")
        val [u, o, v] = l.split(" ")
        val op = match o
            "AND" -> And
            "XOR" -> Xor
            "OR" -> Or
        Rule(u, v, op, r)
    Logic(initial, produce) 

pub fun parse-rule-int()
    val logic-string = parse-rule-string()
    val keys = logic-string.enumerate-keys
    (logic-string.map(fn(k) keys.bin-lookup(k).default(-1)), keys)

pub fun enumerate-keys(logic: logic<k>, ^?cmp: (k, k) -> order): vector<k>
    val keys = logic.initial.map(fst) ++ 
               logic.produce.flatmap(fn(r) [r.first, r.second, r.result])
    keys.merge-sort.dedup.vector

fun bin-lookup(xs: vector<a>, k: a, ^?cmp: (a, a) -> order): pure maybe<int>
    fun go(lo: int, hi: int)
        if lo > hi then Nothing
        else
            val mid = (lo + hi) / 2
            match xs[mid].cmp(k)
                Lt -> go(mid + 1, hi)
                Eq -> Just(mid)
                Gt -> go(lo, mid - 1)
    go(0, xs.length - 1)

fun part1()
    val (Logic(initial, produce), n) = parse-rule-int()
    var value := vector(n.length, Right(-1.int32))
    foreach(initial) fn((i, v))
        value[i] := Right(v.int32)
    foreach(produce) fn(r)
        value[r.result] := Left(r)
    fun calc(i) match value[i]
        Left(r) -> 
            val a = calc(r.first)
            val b = calc(r.second)
            val v = match r.op
                And -> a.and(b)
                Xor -> a.xor(b)
                Or -> a.or(b)
            value[i] := Right(v)
            v
        Right(v) -> v
    var res := Nil
    foreach-indexed(n) fn(i, name: string)
        if name.starts-with("z").is-nothing then return ()
        val x = calc(i).int
        println((name, x))
        res := Cons(x, res)
    res.foldl(0) fn(x, dig) x * 2 + dig

pub fun main()
    with input-full
    part1()