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
    fmt.println ("filehandler got", name)
  bytes,ok := os.read_entire_file (name)
    fmt.println ("filehandler finished read")
  if ok {
    fmt.println ("send abc")
    zd.send(eh, "out", "abc")
    zd.send(eh, "out", string(bytes))
    zd.send(eh, "out", "def")
    fmt.println ("send def")
  } else {
    zd.send (eh, "error", "*** file read error ***")
  }
}

inl_instantiate :: proc (name : string) -> ^zd.Eh {
    fmt.println ("filehandler instantiate", name)
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

    zd.dump_diagram ("obsidian2ghp.drawio")

    reg := zd.make_component_registry(leaves, "obsidian2ghp.drawio")
    zd.dump_registry (reg)
    
    main_container, ok := zd.get_component_instance(reg, "main")
    assert(ok, "Couldn't find main container... check the page name?")
    main_container.handler(main_container, zd.make_message("stdin", "obsidian2ghp.drawio"))

    fmt.println ("*** outputs ***")
    zd.print_output_list(main_container)
    fmt.println ("***         ***")

    fmt.println("--- end ---")
}