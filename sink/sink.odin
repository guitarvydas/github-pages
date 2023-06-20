package sink

import "core:fmt"
import "core:log"
import "core:os"
import "core:strings"
import zd "../../odin0d/0d"
import dt "../../datum"

Instance_Data :: struct {
    output_filename : string,
}


handler :: proc(eh: ^zd.Eh, message: zd.Message, ptr_instance_data: ^any) {
  log.debug ("sink", message.port)
}

instantiate :: proc (name : string) -> ^zd.Eh {
  log.debug ("! sink instantiate")
  instance_data := new (Instance_Data)
  return zd.leaf_new(name, handler, cast(^any)instance_data)
}
