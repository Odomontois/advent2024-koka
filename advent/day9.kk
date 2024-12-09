module advent/day9

import advent/input

struct file
    fid: int
    length: int
    space: int
    pos: int

fun file/empty(space = 0) File(-1, 0, space, 0)

fun show(File(fid, length, space)): string
    "{fid: " ++ fid.show ++ " length: " ++ length.show ++ " space: " ++ space.show ++ "}"

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
    fs.foreach fn(f as File(length = i)) 
        xs[i] := Cons(f, xs[i])
    xs

fun defragment(fs: list<file>)
    var disp := fs.dispense
    var moved := vector(fs.length, False)
    
    fun find(size, cur = 0, best = Nothing): _ maybe<int>
        if cur > size then return best.map fn ((i, _)) i
        val next = match disp[cur]
            Cons(File(fid), _) -> match best
                Just((_, bid)) | bid > fid -> best
                _                          -> Just((cur, fid))
            _ -> best
        find(size, cur + 1, next)

    fun spaceFill(space) match find(space)
            Nothing ->
                [file/empty()]
            Just(i) -> match disp[i]
                Cons(f as File(fid = fid, length = l), rest) -> 
                    disp[i] := rest
                    moved[fid] := True
                    Cons(f(space = 0), spaceFill(space - l))
                _ -> [file/empty()]

    fs.flatmap fn(f)
        trace-show(f)
        if moved[f.fid] 
        then [empty(f.length)]
        else Cons(f(space=0), spaceFill(f.space))

fun part2()
    read-input(9).files.defragment.flatmap fn (File(fid, length, space)) 
            fid.show.replicate(length) ++ ".".replicate(space)  
    .join

pub fun main()
    with input-full
    part1()