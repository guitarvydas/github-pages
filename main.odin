package odin2ghp

import "core:os"
import "core:fmt"
import fr "filereader"
import fw "filewriter"
import dr "deracer"
import zd "../odin0d/0d"

main :: proc() {
  fmt.println("--- begin ---")
    leaves: []zd.Leaf_Initializer = {
        {
            name = "filereader",
            init = fr.instantiate,
        },
        {
            name = "filewriter",
            init = fw.instantiate,
        },
        {
            name = "deracer",
            init = dr.instantiate,
        },
    }

    //zd.dump_diagram ("obsidian2ghp.drawio")

    reg := zd.make_component_registry(leaves, "obsidian2ghp.drawio")
    // zd.dump_registry (reg)
    
    main_container, ok := zd.get_component_instance(reg, "main")
    assert(ok, "Couldn't find main container... check the page name?")
    main_container.handler(main_container, zd.make_message("input_file", "test.txt"))
    //main_container.handler(main_container, zd.make_message("output_file", "/tmp/out.txt"))

    fmt.println ("*** outputs ***")
    //outs := zd.output_list (main_container)
    //fmt.println (outs)
        zd.print_output_list(main_container)
    fmt.println ("***         ***")

    fmt.println("--- end ---")
}