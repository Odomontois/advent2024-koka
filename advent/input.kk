module advent/input

import std/os/file
import std/os/path

pub fun read-input(day: int) : <io, input>  string
  read-text-file(cwd() / "input" / input() / ("day" ++ day.show()))

pub effect fun input(): string

pub val input-base = handler
  fun input() "base"

pub val input-full = handler
  fun input() "full"