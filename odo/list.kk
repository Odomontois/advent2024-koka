module odo/list

fun merge(xs: list<a>, ys: list<a>, less: (a, a) -> bool): list<a>
    match xs
        Nil -> ys
        Cons(x, xrest) -> match ys
            Nil -> xs
            Cons(y, yrest) ->                 
                if less(x, y) 
                then Cons(x, merge(xrest, ys, less))
                else Cons(y, merge(xs, yrest, less))

pub fun merge-sort(xs: list<a>, less: (a, a) -> bool): <div> list<a>
    match xs
        Nil -> Nil
        Cons(_, Nil) -> xs
        _ -> 
            val mid = xs.length / 2
            val left = xs.take(mid)
            val right = xs.drop(mid)
            merge(merge-sort(left, less), merge-sort(right, less), less)

pub fun transpose(xs: list<list<a>>): list<list<a>>
    match xs 
        Nil -> Nil
        Cons(x, Nil) -> x.map(fn(y) Cons(y, Nil))
        Cons(x, xs) -> x.zipwith(xs.transpose())  fn(h, rest) Cons(h, rest)

pub fun at(xs: list<a>, i: int): maybe<a>
    xs.drop(i).head()

pub fun flatmap(b: maybe<a>, f: a -> maybe<b>): maybe<b>
    match b
        Just(x) -> f(x)
        Nothing -> Nothing
    