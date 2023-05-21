package odin2ghp

import "core:os"
import "core:fmt"

main :: proc() {
  fmt.println("--- begin ---")
  m := make(map[string]string);
  m["name"] = "Paul"
  elem,ok := m["name"];
  fmt.println("name=", elem, ok);

  p : rawptr = &m;
  deref_m := (transmute(^map[string]string)p)^
  elem2,ok2 := m["name"];
  fmt.println("name=", elem2, ok2);

  fmt.println("--- end");
}
