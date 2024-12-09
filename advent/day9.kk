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
    ls.foldl((0, 0)) fn((sum, pos), File(fid, sz, sp)) 
        val chck = fid * (sz * pos +  sz * (sz - 1) / 2)
        (sum + chck, pos + sz + sp)

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
                [File(-1, 0, space)]
            Just(i) -> match disp[i]
                Cons(f as File(fid = fid, length = l), rest) -> 
                    disp[i] := rest
                    moved[fid] := True
                    Cons(f(space = 0), spaceFill(space - l))
                _ -> [File(-1, 0, space)]

    fs.flatmap fn(f)
        trace-show(f)
        if moved[f.fid] 
        then [File(-1, 0, space = f.length)]
        else Cons(f(space=0), spaceFill(f.space))

fun part2()
    read-input(9).files.defragment.flatmap fn (File(fid, length, space)) 
            fid.show.replicate(length) ++ ".".replicate(space)  
    .join

pub fun main()
    with input-sample
    part2()