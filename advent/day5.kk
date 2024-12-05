module advent/day5

import advent/input
import odo/list

fun parse()
   val [pref, rest] = read-input(5).split("\n\n")
   val pairs = pref.split("\n").map fn(l) 
                  match l.split("|").map(fn(x) x.parse-int().unjust()) 
                    [x, y] -> (x, y) 

   val seqs = rest.split("\n").map fn(l) 
                   l.split(",").map(fn(x) x.parse-int().unjust())

  
   (pairs, seqs)
alias collected  = vector<vector<bool>>

fun collect-list(xs: list<(int, int)>): div collected
   val size = xs.foldl(0, fn (mx, (i, _)) mx.max(i)) + 1
   val acc-vect: vector<vector<ref<_, bool>>> = vector-init(size, fn (_) vector-init(size, fn (_) ref(False)))
   xs.foreach fn((x, y))
      acc-vect.at(x).map(fn (row) row.at(y).map(fn (r) r.set(True)))
      ()
   acc-vect.map(fn (row) row.map(fn (r) !r))

fun good-boi(s: list<int>, c: collected): div (bool, list<int>)
    fun compare(x: int, y: int): bool
        c.at(x).flatmap(fn (row) row.at(y)).default(False)
    val res = s.merge-sort(compare)
    (res == s, res)

fun mid(xs: list<int>): int
    xs.at(xs.length / 2).default(-1)

fun both-parts()
  val (pairs, seqs) = parse()
  val collected = pairs.collect-list()

  val (good, bad) = seqs.map(fn(s) s.good-boi(collected)).partition(fst)

  val totalGood = good.map(snd).map(mid).sum()
  val totalBad = bad.map(snd).map(mid).sum()
  println(seqs)
  println((good, bad))
  println((totalGood, totalBad))

pub fun main()
  with input-full
  both-parts()