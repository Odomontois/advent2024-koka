module advent/input

import std/os/file
import std/os/path

pub fun read-input(kind: string, day: int) : io string
  read-text-file(cwd() / "input" / kind / ("day" ++ day.show()))