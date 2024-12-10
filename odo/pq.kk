module odo/pq

import std/core/undiv
import std/core/unsafe

type side
    Left
    Right

pub type pq<a>
    Empty
    Leaf(value: a)
    Node(min: a, on: side, left: pq<a>, right: pq<a>)

fun pq/min(p: pq<a>): maybe<a>
    match p
        Leaf(v) -> Just(v)
        Node(min = v) -> Just(v)
        _ -> Nothing

// pub fun list/pq(xs: list<a>, ?cmp: (a, a) -> order): pq<a>
//     fun build(xs': list<_>, sz) match xs
//         Nil -> Empty
//         Cons(x, Nil) -> Leaf(xs.head.unjust)
//         _ ->
//             val m = sz / 2
//             val (l, r) = xs'.split(m)
//             val left = build(l.pretend-decreasing, m)
//             val right = build(r.pretend-decreasing, sz - m)
//             match ?cmp(left.pq/min, right.min)
//                 Lt -> Node(left.min, Left, left, right)
//                 _  -> Node(right.min, Right, right, left)
//     unsafe-total
//         build(xs, xs.length)


            
    


    
