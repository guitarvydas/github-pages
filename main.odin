package odin2ghp

import "core:os"
import "core:fmt"
import "core:log"
import fr "filereader"
import fw "filewriter"
import dr "deracer"
import zd "../odin0d/0d"
import reg "../odin0d/registry0d"

main :: proc() {
  fmt.println("--- begin ---")

    context.logger = log.create_console_logger(
        lowest=.Info,//.Debug, // Or .Info, ... etc.
        opt={.Level, .Time, .Terminal_Color},
    )
    
    leaves: []reg.Leaf_Initializer = {
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

    parts := reg.make_component_registry(leaves, "obsidian2ghp.drawio")
    // zd.dump_registry (parts)

    main_container, ok := reg.get_component_instance(parts, "main")
    assert(ok, "Couldn't find main container... check the page name?")

    main_container.handler(main_container, zd.make_message_from_string ("output_file", "/tmp/out.txt"), nil)
    main_container.handler(main_container, zd.make_message_from_string ("front", "/Users/tarvydas/ps/ghp/front.md"), nil)
    main_container.handler(main_container, zd.make_message_from_string ("obsidian_file", "test.txt"), nil)
    main_container.handler(main_container, zd.make_message_from_string ("back", "/Users/tarvydas/ps/ghp/back.md"), nil)
    main_container.handler(main_container, zd.make_message_from_string ("close", ""), nil)


    fmt.println ("*** outputs ***")
    //outs := zd.output_list (main_container)
    //fmt.println (outs)
        zd.print_output_list(main_container)
    fmt.println ("***         ***")

    fmt.println("--- end ---")
}