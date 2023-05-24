package odin2ghp

import "core:os"
import "core:fmt"
import "filereader"
import zd "../odin0d/0d"
import registry "../odin0d/syntax"

filewriter :: proc (name : string, bytes : []byte) -> bool {
  return os.write_entire_file (name, bytes)
}

main :: proc() {
  fmt.println("--- begin ---")
    leaves: []Leaf_Initializer = {
        {
            name = "Reader",
            init = filereader_instantiate,
        },
    }

    reg := registry.make_component_registry(leaves, "obsidian2ghp.drawio")
    main_container, ok := get_component_instance(reg, "main")
    assert(ok, "Couldn't find main container... check the page name?")
    main_container.handler(main_container, zd.make_message("stdin", "hello"))
    zd.print_output_list(main_container)

  fmt.println("--- file read ---")
  fmt.println("--- end ---")
}