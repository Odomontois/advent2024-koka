module odo/maybe

pub fun whether(cond, f) if cond then Just(f()) else Nothing

pub fun foreach(m: maybe<a>, f : a -> e b): e () match m
    Just(x) -> f(x).ignore()
    Nothing -> ()