package filereader

import "core:fmt"
import "core:os"
import zd "../../odin0d/0d"

fread :: proc (name : string) -> ([]byte, bool) {
  bytes,ok := os.read_entire_file (name)
  return bytes, ok
}

filereader_handler :: proc(eh: ^zd.Eh, message: zd.Message(string)) {
  name : string = message.datum
    fmt.println ("filehandler got", name)
  bytes,ok := os.read_entire_file (name)
    fmt.println ("filehandler finished read")
  if ok {
    fmt.println ("send abc")
    zd.send(eh, "out", "abc")
    zd.send(eh, "out", bytes)
    zd.send(eh, "out", "def")
    fmt.println ("send def")
  } else {
    zd.send (eh, "error", "*** file read error ***")
  }
}

instantiate :: proc (name : string) -> ^zd.Eh {
    fmt.println ("filehandler instantiate", name)
  return zd.make_leaf(name, filereader_handler)
}

