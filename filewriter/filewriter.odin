package filewriter

import "core:fmt"
import "core:os"
import zd "../../odin0d/0d"

filewriter_handler :: proc(eh: ^zd.Eh, message: zd.Message(string)) {
  @(static) name : string = ""
    fmt.println (">>> filewriter", message)
  switch message.port {
  case "filename": name := message.datum
  case "data":
    bytes := transmute([]byte)message.datum
    ok := os.write_entire_file (name, bytes)
    if ok {
    } else {
      zd.send (eh, "error", "*** file write error ***")
    }
  }
}

instantiate :: proc (name : string) -> ^zd.Eh {
  fmt.println ("*** filewriter instantiate")
  return zd.make_leaf(name, filewriter_handler)
}

