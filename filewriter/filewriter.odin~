package filereader

import "core:fmt"
import "core:os"
import zd "../../odin0d/0d"

filereader_handler :: proc(eh: ^zd.Eh, message: zd.Message(string)) {
  name : string = message.datum
  bytes,ok := os.read_entire_file (name)
  if ok {
    zd.send(eh, "out", bytes)
  } else {
    zd.send (eh, "error", "*** file read error ***")
  }
}

instantiate :: proc (name : string) -> ^zd.Eh {
  return zd.make_leaf(name, filereader_handler)
}

