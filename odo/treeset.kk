module odo/treeset


pub value type treeset<a>
    Empty
    Single(value: a)
    TreeNode(node: treenode<a>)

type treenode<a>
    BinNode(left: treenode<a>, value: a, right: treenode<a>)
    TriNode(left: treenode<a>, left-value: a, middle: treenode<a>, right-value: a, right: treenode<a>)
    BinValues(left: a, right: a)
    TriValues(left: a, middle: a, right: a)

value type insertion<a>
    OneNode(node: treenode<a>)
    TwoNodes(left: treenode<a>, value: a, right: treenode<a>)


fun insert-node(node: treenode<a>, x: a, ?cmp: (a, a) -> order): exn insertion<a> match node
    BinValues(left, right) -> OneNode(
        if x < left then TriValues(x, left, right)
        else if x < right then TriValues(left, x, right)
        else TriValues(left, right, x)
    )
    TriValues(left, mid, right) -> if x < mid then TwoNodes(
        if x < left then BinValues(x, left) else BinValues(left, x),
        mid,
        BinValues(mid, right)
    ) else if x < right then TwoNodes(BinValues(left, mid), x, BinValues(x, right))
     else TwoNodes(BinValues(left, mid), right, BinValues(right, x))




pub fun insert(t: treeset<a>, x: a, ?cmp: (a, a) -> order): exn treeset<a> match t
    Empty -> Single(x)
    Single(y) -> if x < y then TreeNode(BinValues(x, y)) else TreeNode(BinValues(y, x))
    TreeNode(node) -> match insert-node(node, x) 
        OneNode(node') -> TreeNode(node')
        TwoNodes(left, value, right) -> TreeNode(BinNode(left, value, right))