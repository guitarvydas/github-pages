package odin2ghp

import "core:os"
import "core:fmt"

Transportable :: distinct []u8

convert_string_to_transportable :: proc (s : string) -> Transportable {
  return transmute(Transportable)s
}

convert_transportable_to_string :: proc (x : Transportable) -> string {
  return transmute(string)x
}

main :: proc() {
  fmt.println("--- begin ---")
  s : string = "pault"
  transportable_s := convert_string_to_transportable (s)
  fmt.println(len(s), s, len(transportable_s), transportable_s)

  st := convert_transportable_to_string (transportable_s)
  fmt.println(len(st), st)
  
  fmt.println("--- end");
}
