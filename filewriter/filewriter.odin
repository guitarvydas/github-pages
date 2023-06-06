package filewriter

import "core:fmt"
import "core:os"
import zd "../../odin0d/0d"

filewriter_handler :: proc(eh: ^zd.Eh, message: zd.Message) {

  fmt.println ("filewriter", message, len(message.port))
  @(static) name : string = ""
  switch message.port {
  case "filename": // name := cast(string)message.datum
  case "data":
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
  return zd.make_leaf(name, filewriter_handler)
}

