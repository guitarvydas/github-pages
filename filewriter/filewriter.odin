package filewriter

import "core:fmt"
import "core:os"
import zd "../../odin0d/0d"
import dt "../../datum"

Data_FileWriter :: struct {
    output_filename : string
}

filewriter_handler :: proc(eh: ^zd.Eh, message: zd.Message, data: ^any) {
  fmt.println ("filewriter", message, len(message.port))
  idata := (cast(^Data_FileWriter)data)^
  switch message.port {
  case "filename": 
      assert (false)
  case "data":
      assert (false)
    // // bytes := cast([]u8)message.datum
    // ok := os.write_entire_file (name, message.datum)
    // if ok {
    // } else {
    //   zd.send (eh, "error", "*** file write error ***")
    // }
  }
}

instantiate :: proc (name : string) -> ^zd.Eh {
  fmt.println ("*** filewriter instantiate")
  instance_data := new (dt.Datum)
  return zd.leaf_new(name, filewriter_handler, cast(^any)instance_data)
}

