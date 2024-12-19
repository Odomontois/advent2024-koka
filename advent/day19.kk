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
    var possible := vector(n + 1, 0)
    possible[0] := 1
    for(n) fn(i)
        if possible[i] == 0 then return ()
        val ways = possible[i]
        foreach(words) fn(word)
            val s = word.count
            if design.slice.subslice(i, i + s) != word.slice return ()
            if i + s <= n then possible[i + s] := possible[i + s] + ways
    possible[n]

fun part1()
    val Words(towels, designs) = parse-words()
    designs.filter(fn(d) possible(towels, d) > 0).length

fun part2()
    val Words(towels, designs) = parse-words()
    designs.map(fn(d) possible(towels, d)).sum

pub fun main()
    with input-full
    part2()