module odo/maybe

pub fun whether(cond, f) if cond then Just(f()) else Nothing

pub fun foreach(m: maybe<a>, f : a -> e b): e () match m
    Just(x) -> f(x).ignore()
    Nothing -> ()

pub fun while-just(next: () -> <div| e> maybe<a>, act : a -> <div| e> b): <div| e> () 
    match next()
        Just(x) -> 
            act(x)
            while-just(next, act)
        Nothing -> ()