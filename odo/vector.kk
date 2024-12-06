module odo/vector

pub fun update-indexed(v: vector<a>, i: int, x: a): <div, exn> vector<a>
  var vm := v
  vm[i] := x
  vm