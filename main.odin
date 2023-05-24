package odin2ghp

import "core:os"
import "core:fmt"
import "filereader"
import zd "../odin0d/0d"

filewriter :: proc (name : string, bytes : []byte) -> bool {
  return os.write_entire_file (name, bytes)
}

main :: proc() {
  fmt.println("--- begin ---")
    leaves: []zd.Leaf_Initializer = {
        {
            name = "Reader",
            init = filereader.instantiate,
        },
    }

    reg := zd.make_component_registry(leaves, "obsidian2ghp.drawio")
    zd.dump_registry (reg)
    main_container, ok := zd.get_component_instance(reg, "main")
    assert(ok, "Couldn't find main container... check the page name?")
    main_container.handler(main_container, zd.make_message("stdin", "hello"))
    zd.print_output_list(main_container)

  fmt.println("--- file read ---")
  fmt.println("--- end ---")
}