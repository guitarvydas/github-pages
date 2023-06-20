package filereader

import "core:fmt"
import "core:log"
import "core:os"
import zd "../../odin0d/0d"
import dt "../../datum"

filereader_handler :: proc(eh: ^zd.Eh, message: zd.Message, instance_data: ^any) {
  // ignore instance_data
  name := dt.datum_to_string (message.datum)
    log.debug ("FILEREADER", message.port)
    fmt.println ("FILEREADER", message.port, message.datum.repr (message.datum))
  bytes,ok := os.read_entire_file (name) // []byte
  p := new (dt.Datum)
  p.ptr = raw_data (bytes)
  p.len = len (bytes)
    p.clone = dt.clone_datum
    p.reclaim = dt.reclaim_datum
  p.repr = dt.datum_to_string
    p.reflection = "Text File"
  if ok {
    log.debug ("filereader ok send")
    zd.send(eh, "out", p^)
  } else {
    log.error ("filereader NOT ok")
    zd.send (eh, "error", dt.str ("*** file read error ***"))
  }
}

instantiate :: proc (name : string) -> ^zd.Eh {
  log.debug ("! filereader instantiate")
  return zd.leaf_new (name, filereader_handler, nil)
}

