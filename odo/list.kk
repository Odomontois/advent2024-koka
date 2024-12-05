module odo/list

fun merge(xs: list<int>, ys: list<int>): list<int>
    match xs
        Nil -> ys
        Cons(x, xrest) -> match ys
            Nil -> xs
            Cons(y, yrest) ->                 
                if x < y 
                then Cons(x, merge(xrest, ys))
                else Cons(y, merge(xs, yrest))

pub fun merge-sort(xs: list<int>): <div> list<int>
    match xs
        Nil -> Nil
        Cons(_, Nil) -> xs
        _ -> 
            val mid = xs.length / 2
            val left = xs.take(mid)
            val right = xs.drop(mid)
            merge(merge-sort(left), merge-sort(right))

pub fun transpose(xs: list<list<a>>): list<list<a>>
    match xs 
        Nil -> Nil
        Cons(x, Nil) -> x.map(fn(y) Cons(y, Nil))
        Cons(x, xs) -> x.zipwith(xs.transpose())  fn(h, rest) Cons(h, rest)
    