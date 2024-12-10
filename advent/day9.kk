module advent/day9

import advent/input
import odo/list

value struct file
    fid: int
    length: int
    space: int
    pos: int

fun file/empty(space = 0) File(-1, 0, space, 0)

fun file/show(f: file): string
    "{fid: " ++ f.fid.show ++ " length: " ++ f.length.show ++ " space: " ++ f.space.show ++ " pos: " ++ f.pos.show ++ "}"

fun files(s: string)
    fun undig(c: char) c.int - '0'.int
    fun go(cs: list<char>, fid = 0, pos = 0) match cs
        Cons(sz, Cons(sp, rest)) -> 
            val f = File(fid, sz.undig, sp.undig, pos)    
            Cons(f, rest.go(fid + 1, pos + f.length + f.space))
        Cons(sz, Nil) -> Cons(File(fid, sz.undig, 0, pos), Nil)
        Nil -> Nil
    s.list.go

fun fill-fwd(fw, bk, pos) match fw
    Cons(f as File(fid, _, sp), rest) -> match bk
        Cons(b as File(bid), _) -> if fid < bid
            then Cons(f(space = 0), fill-bck(rest, bk, sp, pos + f.length))
            else [b(space = 0)]
    Nil -> Nil

fun fill-bck(fw, bk, sp, pos) match bk
    Cons(f as File(length = sz), rest) -> if sz < sp 
        then Cons(f(space = 0, pos = pos), fill-bck(fw, rest, sp - sz, pos + sz))
        else Cons(f(length = sp, space = 0, pos = pos), fill-fwd(fw, Cons(f(length=sz - sp, space=0), rest) , pos + sp))
    Nil -> Nil

fun fill(ls) fill-fwd(ls, ls.reverse, 0)

fun checksum(ls) 
    ls.foldl(0) fn(sum, File(fid, sz, _, pos)) 
        val chck = fid * (sz * pos +  sz * (sz - 1) / 2)
        sum + chck

fun part1()
    read-input(9).files.fill.checksum

fun dispense(fs: list<file>)
    var xs := vector(10, Nil)        
    fs.foreach fn(File(space = sp, pos = pos, length = sz)) 
        if sp > 0 then  xs[sp] := Cons(pos + sz, xs[sp])
    xs

fun defragment(fs: list<file>)
    val fsr = fs.reverse
    var disp := fsr.dispense
    
    fun find(cur, best = Nothing): _ maybe<int>
        if cur == 10 then return best.map fn ((i, _)) i
        val next = match disp[cur]
            Cons(pos, _) -> match best
                Just((_, q)) | q < pos -> best
                _                      -> Just((cur, pos))
            _ -> best
        find(cur + 1, next)

    fun place(f: file) match find(f.length)
            Nothing -> f
            Just(sp) -> match disp[sp]
                Cons(p, rest) | p < f.pos -> 
                    disp[sp] := rest
                    val remain = sp - f.length
                    if remain > 0 then disp[remain] := disp[remain].insert(p + f.length)
                    f(pos = p)
                _ -> f

    fs.reverse.map(place).merge-sort-with fn (f1, f2) f1.pos < f2.pos

fun part2()
    read-input(9).files.defragment.checksum

pub fun main()
    with input-full
    part2()