module advent/day1

import std/os/file
import std/os/path

fun transpose(xs: list<list<a>>): list<list<a>>
    match xs 
        Nil -> Nil
        Cons(x, Nil) -> x.map(fn(y) Cons(y, Nil))
        Cons(x, xs) -> x.zipwith(xs.transpose())  fn(h, rest) Cons(h, rest)

fun merge(xs: list<int>, ys: list<int>): list<int>
    match xs
        Nil -> ys
        Cons(x, xrest) -> match ys
            Nil -> xs
            Cons(y, yrest) ->                 
                if x < y 
                then Cons(x, merge(xrest, ys))
                else Cons(y, merge(xs, yrest))

fun merge-sort(xs: list<int>): <div> list<int>
    match xs
        Nil -> Nil
        Cons(_, Nil) -> xs
        _ -> 
            val mid = xs.length / 2
            val left = xs.take(mid)
            val right = xs.drop(mid)
            merge(merge-sort(left), merge-sort(right))
    

fun part1(input: list<list<int>>)
    val x = input.transpose().map(fn(l) l.merge-sort())
    // println(x)
    match x 
        [l1, l2] -> (l1.zipwith(l2) fn (a, b) (a - b).abs()).sum()
        _ -> -1

fun part2(input: list<list<int>>)
    val [l1, l2] = input.transpose()
    0
    // println(x)

    
pub fun main()
  val input = read-text-file(cwd() / "input" / "full" / "day1")
  val pairs = input
                .split("\n")
                .map(fn(x) x.split("   ") )
                .map(fn(l) l.filter-map fn(x) x.parse-int())
  val p1 = pairs.part1()
  
  println(p1)