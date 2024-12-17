module advent/day17

import std/num/int64
import advent/input
import odo/list

value struct regs
    a: int64
    b: int64 = 0.int64
    c: int64 = 0.int64
    p: int64 = 0.int64

fun show(Regs(a, b, c, p)): string
    "Regs{" ++ a.show ++ ", " ++ b.show ++ ", " ++ c.show ++ ", " ++ p.show ++  "}"

fun combo(i: int64, ?r: regs) match i.int
    4 -> r.a
    5 -> r.b
    6 -> r.c
    _ -> i

effect ctl write(x: int64): unit

val seven = 7.int64

fun adv(x, ?r: regs): write regs r(a = r.a.shr(combo(x).int))           //0
fun bxl(x, ?r: regs): write regs r(b = r.b.xor(x))                      //1
fun bst(x, ?r: regs): write regs r(b = combo(x).and(seven))             //2
fun jnz(x, ?r: regs): write regs if r.a == zero then r else r(p = x)    //3 
fun bxs(x, ?r: regs): write regs r(b = r.b.xor(r.c))                    //4
fun out(x, ?r: regs): write regs                                        //5
    write(combo(x).and(seven))
    r
fun bdv(x, ?r: regs): write regs r(b = r.a.shr(combo(x).int))           //6
fun cdv(x, ?r: regs): write regs r(c = r.a.shr(combo(x).int))           //7

val instructions = vector([adv, bxl, bst, jnz, bxs, out, bdv, cdv])

fun read-inp()
    val [regs-str, instr-str] = read-input(17).split("\n\n")
    val [a, b, c] = regs-str.split("\n").filter-map fn(x) 
                        x.slice.drop(12).string.parse-int 
                    .map(int64)
    val regs = Regs(a, b, c, zero)
    val insts = instr-str.slice.drop(9).string.split(",").filter-map fn(x) x.parse-int
    (regs, insts)

fun exec(regs, is): <pure, write> regs
    val iv = is.chunks2.vector
    fun go(pr) match iv.at(pr.p.int)
        Nothing -> pr
        Just((ic, x)) -> 
            val inst = instructions[ic]
            val r = pr(p = pr.p.inc)
            go(inst(x.int64))
    go(regs)

fun part1()
    val (regs, is) = read-inp()
    var cur: ctx<list<int64>> := ctx _
    with handler 
        fun write(x) cur := cur ++ ctx Cons(x, _)
    exec(regs, is)
    (cur ++. Nil).map(show).join(",")

fun attempt(is: list<int>, a: int, wants: list<int64>): pure bool
    var want := wants
    with handler
        ctl write(x) match want
            Cons(y, ys) | y == x -> 
                want := ys
                resume(())
            _ -> False
    exec(Regs(a = a.int64), is)
    want == Nil


fun part2()
    val (_, is) = read-inp()
    fun search(wants: list<int64>): _ list<int> match wants
        Nil -> [0]
        Cons(x, xs) -> 
            search(xs).flatmap fn(a)
                list(0, 7).filter-map fn(d)
                    val a' = a * 8 + d
                    if attempt(is, a', Cons(x, xs))
                    then Just(a')  else Nothing 
    search(is.map(int64))



pub fun main()
    with input-full
    part2()

// 2,5,2,1,7,5,2,7,4
