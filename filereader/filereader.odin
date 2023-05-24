package filereader

import "core:os"
import zd "../../odin0d/0d"

fread :: proc (name : string) -> ([]byte, bool) {
  bytes,ok := os.read_entire_file (name)
  return bytes, ok
}

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

