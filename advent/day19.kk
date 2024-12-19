module advent/day19

import advent/input
import odo/list

value struct words
   towels: list<string>
   designs: list<string>

fun show(w: words): string
    "Words(" ++ w.towels.show ++ ", " ++ w.designs.show ++ ")"

fun parse-words()
    val [first, rest] = read-input(19).split("\n\n")
    val towels = first.split(", ")
    val designs = rest.split("\n")
    Words(towels, designs)


fun possible(words: list<string>, design: string)
    val n = design.count
    var possible := vector(n, False)
    possible[0] := True
    for-while(n) fn(i)
        if !possible[i] then return Nothing
        foreach-while(words) fn(word)
            val s = word.count
            if design.slice.subslice(i, i + s) != word.slice return Nothing
            match (i + s).cmp(n)
                Lt -> 
                    possible[i + s] := True
                    Nothing
                Eq -> Just(())
                Gt -> Nothing
    .is-just

fun part1()
    val Words(towels, designs) = parse-words()
    designs.filter(fn(d) possible(towels, d)).length

pub fun main()
    with input-full
    part1()