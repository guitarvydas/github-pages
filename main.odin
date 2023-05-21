package odin2ghp

import "core:os"
import "core:fmt"

filereader :: proc (name : string) -> ([]byte, bool) {
  bytes,ok := os.read_entire_file (name)
  return bytes, ok
}

filewriter :: proc (bytes : []byte) -> bool {
  return os.write_entire_file ("/tmp/front.md", bytes)
}

main :: proc() {
  fmt.println("--- begin ---")
  bytes, okr := filereader ("/Users/tarvydas/ps/ghp/front.md")
  okw := filewriter (bytes)
  fmt.println("--- end ", okr, okw, " ---")
}