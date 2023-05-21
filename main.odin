package odin2ghp

import "core:os"
import "core:fmt"

main :: proc() {
  fmt.println("--- begin ---")
  bytes,okr := os.read_entire_file ("/Users/tarvydas/ps/ghp/front.md")
  okw := os.write_entire_file ("/tmp/front.md", bytes)
  fmt.println("--- end ", okr, okw, " ---")
m := make(map[string]int);
defer delete(m);
m["Paul"] = 7;
{
elem,ok := m["Paul"];
fmt.println(elem, ok);
}
{
elem,ok := m["Bob"];
fmt.println(elem, ok);
}
//  context.user_ptr = ???paul = "abc"
//  fmt.println (context.paul)
}