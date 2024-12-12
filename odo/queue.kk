module queue

value struct queue<a>
    front : list<a>
    back : list<a>

pub fun empty(): queue<a>
    Queue(Nil, Nil)

pub fun queue(l: list<a>): queue<a>
    Queue(l, Nil)

pub fun enqueue(q: queue<a>, x: a): queue<a>
    Queue(q.front, Cons(x, q.back))

pub fun dequeue(q: queue<a>): maybe<(a, queue<a>)>
    match q
        Queue(Cons(x, xs), back) -> Just((x, Queue(xs, back)))
        Queue(Nil, back) -> match back.reverse
            Nil -> Nothing
            Cons(x, xs) -> Just((x, Queue(xs, Nil)))
