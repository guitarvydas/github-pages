package buffer

import "core:fmt"
import "core:log"
import zd "../../odin0d/0d"
import dt "../../datum"

Instance_Data :: struct {
    buffer : [dynamic]byte,
}


handler :: proc(eh: ^zd.Eh, message: zd.Message, ptr_instance_data: ^any) {
  log.debug ("buffer", message.port)
  fmt.println ("buffer", message.port)
  d := cast(^Instance_Data)ptr_instance_data
  switch message.port {
  case "open":
    d.buffer = [dynamic]byte{}
  case "append":
    append (&d.buffer, dt.datum_to_string (message.datum))
  case "close":
      datum := dt.create_datum (raw_data (d.buffer), len (d.buffer), dt.datum_to_string, "Buffer")
      zd.send (eh, "output", datum)
  }
}

instantiate :: proc (name : string) -> ^zd.Eh {
  log.debug ("! buffer instantiate")
  instance_data := new (Instance_Data)
  return zd.leaf_new(name, handler, cast(^any)instance_data)
}
