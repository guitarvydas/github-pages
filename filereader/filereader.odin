package filereader

import "core:fmt"
import "core:os"
import zd "../../odin0d/0d"

filereader_handler :: proc(eh: ^zd.Eh, message: zd.Message(string)) {
  name : string = message.datum
    fmt.println (">>> filereader", message)
  bytes,ok := os.read_entire_file (name)
  if ok {
    fmt.println ("filereader ok send")
    zd.send(eh, "out", transmute(string)bytes)
  } else {
    fmt.println ("filereader NOT ok")
    zd.send (eh, "error", "*** file read error ***")
  }
  zd.print_output_list (eh)
}

instantiate :: proc (name : string) -> ^zd.Eh {
  fmt.println ("*** filereader instantiate")
  return zd.make_leaf(name, filereader_handler)
}

