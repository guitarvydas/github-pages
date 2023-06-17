package filewriter

import "core:fmt"
import "core:log"
import "core:os"
import "core:strings"
import zd "../../odin0d/0d"
import dt "../../datum"

Instance_Data :: struct {
    output_filename : string,
    fd : os.Handle,
}

filewriter_handler :: proc(eh: ^zd.Eh, message: zd.Message, ptr_instance_data: ^any) {
  // in this early version, it is vital to send a filename first, then multiple data's, then close
  log.info ("filewriter", message.port)
  d := cast(^Instance_Data)ptr_instance_data
  switch message.port {
  case "filename":
      d.output_filename = strings.clone (dt.datum_to_string (message.datum))
	flags: int = os.O_WRONLY|os.O_CREATE
	mode: int = 0
      fd, err := os.open(d.output_filename, flags, mode)
      if err == 0 {
      } else {
        zd.send (eh, "error", dt.str ("*** file write open error ***"))
      }
      d.fd = fd
  case "data":
	_, write_err := os.write(d.fd, transmute ([]u8)dt.datum_to_string (message.datum))
      if write_err == 0 {
      } else {
        zd.send (eh, "error", dt.str ("*** file write error ***"))
      }
  case "close":
    os.close (d.fd)
  }
}

instantiate :: proc (name : string) -> ^zd.Eh {
  log.info ("filewriter instantiate")
  instance_data := new (Instance_Data)
  return zd.leaf_new(name, filewriter_handler, cast(^any)instance_data)
}
