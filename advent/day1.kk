module advent/day1

import advent/input
import odo/list


fun part1(input: list<list<int>>)
    val x = input.transpose().map(fn(l) l.merge-sort(fn (x, y) x < y))
    match x 
        [l1, l2] -> (l1.zipwith(l2) fn (a, b) (a - b).abs()).sum()
        _ -> -1

pub fun main()
  val input = read-input("full", 1)
  val pairs = input
                .split("\n")
                .map(fn(x) x.split("   ") )
                .map(fn(l) l.filter-map fn(x) x.parse-int())
  val p1 = pairs.part1()
  
  println(p1)