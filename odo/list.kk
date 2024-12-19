module odo/list

import std/core/undiv

fun merge(xs: list<a>, ys: list<a>, ?(<): (a, a) -> e bool): e list<a>
    match xs
        Nil -> ys
        Cons(x, xrest) -> match ys
            Nil -> xs
            Cons(y, yrest) ->                 
                if x < y 
                then Cons(x, merge(xrest, ys))
                else Cons(y, merge(xs, yrest))

fun merge-sort(xs: list<a>, ?(<): (a, a) -> e bool): e list<a>
    match xs
        Nil -> Nil
        Cons(_, Nil) -> xs
        _ -> 
            val mid = xs.length / 2
            val left = xs.take(mid)
            val right = xs.drop(mid)
            merge(merge-sort(left.pretend-decreasing), merge-sort(right.pretend-decreasing))

pub fun merge-sort-with(xs: list<a>, (<): (a, a) -> e bool): e list<a>
    merge-sort(xs)  

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

pub fun insert-with(xs: list<a>, x: a, ^?key: a -> b, ^?cmp: (b, b) -> e order): e list<a>
    match xs
        Nil -> Cons(x, Nil)
        Cons(y, ys) -> 
            if cmp(key(x), key(y)) == Lt
            then Cons(x, Cons(y, ys))
            else Cons(y, ys.insert-with(x))

pub fbip fun update(xs: list<(a, w)>, x: a, ^f: w -> e w, ^?order2: (a, a) -> e order2<a>): e list<(a, w)>
    match xs
        Nil -> Nil
        Cons((y, w), xs') -> match order2(x, y) 
            Lt2(_, y') -> Cons((y', w), xs')
            Eq2(y') -> Cons((y', f(w)), xs')
            Gt2(x', y') -> Cons((y', w), xs'.update(x', f))

pub fbip fun union'(xs: list<a>, ys: list<a>, ^?order2: (a, a) -> e order2<a>): e list<a>
    match xs
        Nil -> ys
        Cons(x, xs') -> match ys 
            Nil -> Cons(x, xs')
            Cons(y, ys') -> match order2(x, y)
                Lt2(x', y') -> Cons(x', xs'.union'(Cons(y', ys')))
                Eq2(x') -> Cons(x', xs'.union'(ys'))
                Gt2(y', x') -> Cons(y', Cons(x', xs').pretend-decreasing.union'(ys'))


pub fun union(xs: list<a>, ys: list<a>, ^?cmp: (a, a) -> e order): e list<a>
    match xs
        Nil -> ys
        Cons(x, xs') ->  match ys 
            Nil -> xs
            Cons(y, ys') -> match cmp(x, y)
                Lt -> Cons(x, xs'.union(ys))
                Eq -> Cons(x, xs'.union(ys'))
                Gt -> Cons(y, xs.union(ys'))

pub fip(1) fun union-single(xs: list<a>, y: a, ^?order2: (a, a) -> e order2<a>): e list<a>
    match xs
        Nil -> Cons(y, Nil)
        Cons(x, xs') -> match order2(x, y)
            Lt2(x', y') -> Cons(x', xs'.union-single(y'))
            Eq2(x') -> Cons(x', xs')
            Gt2(y', x') -> Cons(y', Cons(x', xs'))

pub fun collect (xs: list<a>, f: a -> <exn| e> b): e list<b>
    xs.filter-map fn(x) try(fn() Just(f(x))) fn(_) Nothing

pub fun chunks(xs: list<a>, n: int): list<list<a>> match xs
    Nil -> Nil
    _ -> 
        val (chunk, rest) = xs.split(n)
        Cons(chunk, rest.pretend-decreasing.chunks(n))

pub fbip fun chunks2(xs: list<a>): list<(a, a)> match xs
    Cons(a, Cons(b, xs')) -> Cons((a, b), xs'.chunks2)
    _ -> Nil

pub fun list-pair([x, y]: list<a>): exn (a, a) (x, y)


    