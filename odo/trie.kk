module odo/trie

pub type trie<a>
    Single(key: int, value: a)
    Straw(common: int, suffix: trie<a>)
    Bin(one: trie<a>, zero: trie<a>)


pub fun common(x: int, y: int, acc: int = 0): (int, int, int) { (0, 0, 0) }

pub fun insert(t: trie<a>, key: int, value: a): trie<a> match t
    Single(key', _) | key == key' -> Single(key, value)
    Single(key', v)  -> 
        val (common, x, y) = common(key, key', 0)
        if common == 0 then Bin(Single(key, value), Single(key', v))
        else if x then Straw(common, Bin(Single(key, value), Single(key', v)))
        else Straw(common, Bin(Single(x, v), Single(y, value)))

    _ -> t
