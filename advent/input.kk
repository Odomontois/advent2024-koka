module advent/input

import std/os/file
import std/os/path

pub type input-kind
    Sample
    Full

fun show(i) match i
    Sample -> "sample"
    Full -> "full"

pub fun read-input(day: int) : <io, input>  string
  read-text-file(cwd() / "input" / input().show / ("day" ++ day.show()))

pub effect fun input(): input-kind

pub val input-sample = handler
  fun input() Sample

pub val input-full = handler
  fun input() Full