module odo/maybe

pub fun whether(cond, f) if cond then Just(f()) else Nothing