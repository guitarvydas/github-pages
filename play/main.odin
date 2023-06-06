package odin2ghp

import "core:os"
import "core:fmt"

main :: proc() {
  fmt.println("--- begin ---")
  s : string = "pault"
  transportable_s := transmute([]u8)s
  fmt.println(len(s), s, len(transportable_s), transportable_s)

  i : u8 = 7
  transportable_i := []u8{i}
  fmt.println(i, len(transportable_i), transportable_i)
  
  fmt.println("--- end");
}
