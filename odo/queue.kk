module odo/queue

pub value struct queue<a>
    front : list<a>
    back : list<a>

pub fun queue/empty(): queue<a>
    Queue(Nil, Nil)

pub fun list/queue(l: list<a>): queue<a>
    Queue(l, Nil)

pub fun queue/enqueue(q: queue<a>, x: a): queue<a>
    Queue(q.front, Cons(x, q.back))

pub fun queue/dequeue(q: queue<a>): maybe<(a, queue<a>)>
    match q
        Queue(Cons(x, xs), back) -> Just((x, Queue(xs, back)))
        Queue(Nil, back) -> match back.reverse
            Nil -> Nothing
            Cons(x, xs) -> Just((x, Queue(xs, Nil)))
