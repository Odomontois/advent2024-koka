module odo/heap

pub type heap<a>
    Empty
    Single(value: a)
    Bin(value: a, rank: int, left: heap<a>, right: heap<a>)

pub fun heap/show(h: heap<a>, ?show: a -> string): string match h
    Empty -> "Empty"
    Single(x) -> "Single{" ++ show(x) ++ "}"
    Bin(x, k, l, r) -> "Bin(" ++ show(x) ++ ", " ++ k.show ++ "){"  ++ l.show ++ "; " ++ r.show ++ "}"

fun rank(h: heap<a>): int match h
    Empty -> 0
    Single(_) -> 1
    Bin(_, r, _, _) -> r

pub fun insert(h: heap<a>, x: a, ^?cmp: (a, a) -> order): heap<a> match h
    Empty -> Single(x)
    Single(y) -> if x < y
        then Bin(x, 2, Single(y), Empty) 
        else Bin(y, 2, Single(x), Empty)
    Bin(y, k, l, r) -> 
        val (x', y') = if x < y then (x, y) else (y, x)
        if l.rank == r.rank then Bin(x', k + 1, Bin(y', k, l, r), Empty)
        else Bin(x', k, l, r.insert(y'))

fbip fun remove-right(h: heap<a>, c: ctx<heap<a>> = ctx _): (heap<a>, maybe<a>)
    match h
        Empty -> (c ++. Empty, Nothing)
        Single(x) -> (c ++. Empty, Just(x))
        Bin(x, k, l, r) -> remove-right(r, c ++ ctx Bin(x, k, l, _))

fun fix-down(h: heap<a>, c: ctx<heap<a>> = ctx _, ^?cmp: (a, a) -> order) : heap<a>
    match h
        Empty -> c ++. Empty
        Single(x) -> c ++. Single(x)
        Bin(x, k, l, r) -> Empty
            

fun min(^l: heap<a>): maybe<a> match l
    Empty -> Nothing
    Single(x) -> Just(x)
    Bin(x, _, _, _) -> Just(x)

pub fun delete-min(h: heap<a>, ^?cmp: (a, a) -> order): maybe<(a, heap<a>)> match h
    Empty -> Nothing
    Single(x) -> Just((x, Empty))
    Bin(x, k, l, r) -> match r.delete-min 
        Nothing -> Just((x, l))
        Just((y, r')) -> 
            val (x', l') = match l 
                Empty -> (y, Empty)
                Single(z) -> if z < y 
                    then  (z, Single(y))
                    else  (y, Single(z))
                Bin(z, lk, ll, lr) -> if z < y 
                    then (z, Bin(y, k, ll, lr))
                    else (y, Bin(z, lk, ll, lr))
            Just((x, Bin(x', k, l', r')))




