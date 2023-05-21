package odin2ghp

import "core:os"
import "core:fmt"
import "filereader"

filewriter :: proc (name : string, bytes : []byte) -> bool {
  return os.write_entire_file (name, bytes)
}

// main :: proc() {
//     fmt.println("*** Obsidian to Github Pages ***")

//     {
//         echo_handler :: proc(eh: ^Eh, message: Message(string)) {
//             send(eh, "stdout", message.datum)
//         }

//         echo0 := make_leaf("10", echo_handler)
//         echo1 := make_leaf("11", echo_handler)

//         top := make_container("Top")

//         top.children = {
//             o2g,
//         }

//         top.connections = {
//             {.Down,   {nil, "stdin"},            {&top.children[0].input, "go"}},
//             {.Up,     {top.children[0], "done"}, {&top.output, "stdout"}},
//         }

// 	top.handler(top, make_message("stdin", "hello"))
//         print_output_list(top)
//     }

main :: proc() {
  fmt.println("--- begin ---")
  bytes, okr := filereader.fread ("/Users/tarvydas/ps/ghp/front.md")
  okw := filewriter ("/tmp/frontabc.md", bytes)
  fmt.println("--- end ", okr, okw, " ---")
}