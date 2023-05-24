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

filereader_instantiate :: proc (name : string) -> ^zd.Eh {
  return zd.make_leaf(name, filereader_handler)
}

// leaf_filereader_init :: proc(name: string) -> ^Eh {
//     @(static) counter := 0
//     counter += 1

//     name_with_id := fmt.aprintf("Echo (ID:%d)", counter)
//     return make_leaf(name_with_id, leaf_echo_proc)
// }
