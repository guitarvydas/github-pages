package filewriter

import "core:fmt"
import "core:log"
import "core:os"
import "core:strings"
import zd "../../odin0d/0d"
import dt "../../datum"

Instance_Data :: struct {
    output_filename : string,
}


filewriter_handler :: proc(eh: ^zd.Eh, message: zd.Message, ptr_instance_data: ^any) {
  log.debug ("filewriter", message.port)
  d := cast(^Instance_Data)ptr_instance_data
  switch message.port {
  case "filename":
      d.output_filename = strings.clone (dt.datum_to_string (message.datum))
  case "data":
      ok := os.write_entire_file (d.output_filename, transmute ([]u8)dt.datum_to_string (message.datum))
      if ok {
      } else {
        zd.send (eh, "error", dt.str ("*** file write error ***"))
      }
  case:
      fmt.println ("unhandled message in filewriter", message.port) 
      assert (false)
  }
}

instantiate :: proc (name : string) -> ^zd.Eh {
  log.debug ("! filewriter instantiate")
  instance_data := new (Instance_Data)
  return zd.leaf_new(name, filewriter_handler, cast(^any)instance_data)
}
