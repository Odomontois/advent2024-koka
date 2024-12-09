module advent/day9

import advent/input

struct file
    fid: int
    length: int
    space: int

fun show(File(fid, length, space)): string
    "{fid: " ++ fid.show ++ " length: " ++ length.show ++ " space: " ++ space.show ++ "}"

fun files(s: string)
    fun undig(c: char) c.int - '0'.int
    fun go(cs: list<char>, fid) match cs
        Cons(sz, Cons(sp, rest)) -> Cons(File(fid, sz.undig, sp.undig), rest.go(fid + 1))
        Cons(sz, Nil) -> Cons(File(fid, sz.undig, 0), Nil)
        Nil -> Nil
    s.list.go(0)

fun fill-fwd(fw, bk) match fw
    Cons(File(fid, sz, sp), rest) -> match bk
        Cons(File(bid, bsz, _), _) -> if fid < bid
            then Cons(File(fid, sz, 0), fill-bck(rest, bk, sp))
            else [File(bid, bsz, 0)]
    Nil -> Nil

fun fill-bck(fw, bk, sp) match bk
    Cons(File(fid, sz, _), rest) -> if sz < sp 
        then Cons(File(fid, sz, 0), fill-bck(fw, rest, sp - sz))
        else Cons(File(fid, sp, 0), fill-fwd(fw, Cons(File(fid, sz - sp, 0), rest)))
    Nil -> Nil

fun fill(ls) fill-fwd(ls, ls.reverse)

fun checksum(ls) 
    ls.foldl((0, 0)) fn((sum, pos), File(fid, sz, _)) 
        val chck = fid * (sz * pos +  sz * (sz - 1) / 2)
        (sum + chck, pos + sz)


fun part1()
    read-input(9).files.fill.checksum

pub fun main()
    with input-full
    part1()