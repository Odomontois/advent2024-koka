module advent/day17

import std/num/int32
import advent/input
import odo/list

value struct regs
    a: int32
    b: int32
    c: int32
    p: int32
    outs: list<int32>

fun show(Regs(a, b, c, p, outs)): string
    "Regs{" ++ a.show ++ ", " ++ b.show ++ ", " ++ c.show ++ ", " ++ p.show ++ ", " ++ outs.show ++ "}"

fun combo(i: int32, ?r: regs) match i.int
    4 -> r.a
    5 -> r.b
    6 -> r.c
    _ -> i

val seven = 7.int32
fun adv(x, ?r: regs) r(a = r.a.shr(combo(x).int))
fun bxl(x, ?r: regs) r(b = r.b.xor(x))
fun bst(x, ?r: regs) r(b = combo(x).and(seven))
fun jnz(x, ?r: regs) if r.a == zero then r else r(p = x)
fun bxs(x, ?r: regs) r(b = r.b.xor(r.c))
fun out(x, ?r: regs) r(outs = Cons(combo(x).and(seven), r.outs))
fun bdv(x, ?r: regs) r(b = r.a.shr(combo(x).int))
fun cdv(x, ?r: regs) r(c = r.a.shr(combo(x).int))

val instructions = vector([adv, bxl, bst, jnz, bxs, out, bdv, cdv])

fun read-inp()
    val [regs-str, instr-str] = read-input(17).split("\n\n")
    val [a, b, c] = regs-str.split("\n").filter-map fn(x) 
                        x.slice.drop(12).string.parse-int 
                    .map(int32)
    val regs = Regs(a, b, c, zero, Nil)
    val insts = instr-str.slice.drop(9).string.split(",").filter-map fn(x) x.parse-int
    (regs, insts)

fun exec(regs, is)
    val iv = is.chunks2.vector
    fun go(pr)
        val j = pr.p.int
        match iv.at(j)
            Nothing -> pr
            Just((ic, x)) -> 
                val inst = instructions[ic]
                val r = pr(p = pr.p.inc)
                go(inst(x.int32))
    go(regs)

fun part1()
    val (regs, is) = read-inp()
    exec(regs, is).outs.reverse.map(show).join(",")

pub fun main()
    with input-full
    part1()

// 2,5,2,1,7,5,2,7,4
