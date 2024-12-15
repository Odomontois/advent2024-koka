module odo/string

import std/core/sslice
import std/core/undiv



pub fun index-of(s: string, c: char): maybe<int>
    fun go(sl, i) match sl.next()
        Just((c1, rest)) -> 
            if c1 == c then Just(i) 
            else go(rest.pretend-decreasing, i + 1)
        Nothing -> Nothing

    go(s.slice(), 0)
    