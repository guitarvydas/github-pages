package odin2ghp

import "core:os"
import "core:fmt"
import "filereader"
import zd "../odin0d/0d"

fread :: proc (name : string) -> ([]byte, bool) {
  bytes,ok := os.read_entire_file (name)
  return bytes, ok
}

inl_filereader_handler :: proc(eh: ^zd.Eh, message: zd.Message(string)) {
  name : string = message.datum
  bytes,ok := os.read_entire_file (name)
  if ok {
    zd.send(eh, "out", string(bytes))
  } else {
    zd.send (eh, "error", "*** file read error ***")
  }
}

inl_instantiate :: proc (name : string) -> ^zd.Eh {
  return zd.make_leaf(name, inl_filereader_handler)
}

///

filewriter :: proc (name : string, bytes : []byte) -> bool {
  return os.write_entire_file (name, bytes)
}

main :: proc() {
  fmt.println("--- begin ---")
    leaves: []zd.Leaf_Initializer = {
        {
            name = "filereader",
            init = inl_instantiate,
        },
    }

    //zd.dump_diagram ("obsidian2ghp.drawio")

    reg := zd.make_component_registry(leaves, "obsidian2ghp.drawio")
    //zd.dump_registry (reg)
    
    main_container, ok := zd.get_component_instance(reg, "main")
    assert(ok, "Couldn't find main container... check the page name?")
    main_container.handler(main_container, zd.make_message("stdin", "test.txt"))

    fmt.println ("*** outputs ***")
    zd.print_output_list(main_container)
    fmt.println ("***         ***")

    fmt.println("--- end ---")
}