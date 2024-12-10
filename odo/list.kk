module odo/list

import std/core/undiv

fun merge(xs: list<a>, ys: list<a>, ?less: (a, a) -> e bool): e list<a>
    match xs
        Nil -> ys
        Cons(x, xrest) -> match ys
            Nil -> xs
            Cons(y, yrest) ->                 
                if less(x, y) 
                then Cons(x, merge(xrest, ys))
                else Cons(y, merge(xs, yrest))

fun merge-sort-it(xs: list<a>, ?less: (a, a) -> e bool): e list<a>
    match xs
        Nil -> Nil
        Cons(_, Nil) -> xs
        _ -> 
            val mid = xs.length / 2
            val left = xs.take(mid)
            val right = xs.drop(mid)
            merge(merge-sort-it(left.pretend-decreasing), merge-sort-it(right.pretend-decreasing))

pub fun merge-sort-with(xs: list<a>, less: (a, a) -> e bool): e list<a>
    merge-sort-it(xs)

pub fun merge-sort(xs: list<a>, ?cmp: (a, a) -> e order): e list<a>
    merge-sort-it(xs, fn(x, y) cmp(x, y) == Lt)

pub fun transpose(xs: list<list<a>>): list<list<a>>
    match xs 
        Nil -> Nil
        Cons(x, Nil) -> x.map(fn(y) Cons(y, Nil))
        Cons(x, xs) -> x.zipwith(xs.transpose())  fn(h, rest) Cons(h, rest)

pub fun at(xs: list<a>, i: int): maybe<a>
    xs.drop(i).head()

pub fun find-indexed-maybe(l: list<a>, p: (int, a) -> e maybe<b>): e maybe<b>
    fun go(i, xs) match xs
        Nil -> Nothing  
        Cons(x, xs) -> match p(i, x)
            Nothing -> go(i + 1, xs)
            jy -> jy
    go(0, l)

pub fun dedup(xs: list<a>, ?(==): (a, a) -> e bool): e list<a>
    match xs
        Nil -> Nil
        Cons(x, xs) -> xs.dedup-prev(x)

fun dedup-prev(xs: list<a>, prev: a, ?(==): (a, a) -> e bool): e list<a>
    match xs
        Nil -> Cons(prev, Nil)
        Cons(x, xs) -> 
            if prev == x 
            then xs.dedup-prev(prev)
            else Cons(prev, xs.dedup-prev(x))

pub fun flatmap-index(xs: list<a>, f: (int, a) -> e list<b>): e list<b>
  fun flatmap-pre(ys, zs, i )
    match ys
      Cons(y,yy) -> Cons(y,flatmap-pre(yy,zs, i))
      Nil -> match zs
        Cons(z,zz) -> flatmap-pre(f(i, z),zz, i+1)
        Nil -> Nil
  flatmap-pre([],xs,0)

pub fun insert(xs: list<a>, x: a, ?cmp: (a, a) -> e order): e list<a>
    match xs
        Nil -> Cons(x, Nil)
        Cons(y, ys) -> 
            if cmp(x, y) == Lt
            then Cons(x, xs)
            else Cons(y, ys.insert(x))

pub fbip fun union(xs: list<a>, ys: list<a>, ?order2: (a, a) -> e order2<a>): e list<a>
    match xs
        Nil -> ys
        Cons(x, xs') -> match ys 
            Nil -> Cons(x, xs')
            Cons(y, ys') -> match order2(x, y)
                Lt2(x', y') -> Cons(x', xs'.union(Cons(y', ys')))
                Eq2(x') -> Cons(x', xs'.union(ys'))
                Gt2(y', x') -> Cons(y', Cons(x', xs').pretend-decreasing.union(ys'))

    