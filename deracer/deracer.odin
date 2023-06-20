package deracer

import "core:fmt"
import "core:log"
import "core:os"
import "core:mem"
import zd "../../odin0d/0d"
import dt "../../datum"


States :: enum {idle, waitingForFirst, waitingForSecond}

Two_saved_datums :: struct {
  first : dt.Datum,
  second : dt.Datum
}

deracer_handler :: proc(eh: ^zd.Eh, message: zd.Message, ptr_instance_data_any: ^any) {
  ptr_d := cast(^Two_saved_datums)ptr_instance_data_any
  log.debug ("deracer", transmute(States)eh.state, message.port)
  fmt.println ("deracer", transmute(States)eh.state, message.port)
  switch transmute(States)eh.state {
    case .idle:
      switch message.port {
        case "first":
          ptr_d^.first = message.datum.clone (message.datum)
          zd.set_state (eh, States.waitingForSecond)
        case "second":
          ptr_d^.second = message.datum.clone (message.datum)
          zd.set_state (eh, States.waitingForFirst)
        case:
	  log.debug ("deracer", transmute(States)eh.state, message)
          zd.send (eh, "error", dt.str ("sequencing error A"))
      }
    case .waitingForSecond:
      switch message.port {
        case "second":
          ptr_d^.second = message.datum.clone (message.datum)
          sequential_send (eh, ptr_d)
        case : zd.send (eh, "error", dt.str ("sequencing error B"))
      }
    case .waitingForFirst:
      switch message.port {
        case "first":
          ptr_d^.first = message.datum.clone (message.datum)
          sequential_send (eh, ptr_d)
        case : zd.send (eh, "error", dt.str ("sequencing error C"))
      }
   }
}

sequential_send :: proc (eh: ^zd.Eh, instance_data: ^Two_saved_datums) {
  zd.set_state (eh, States.idle)
  zd.send (eh, "first", instance_data.first)
  zd.send (eh, "second", instance_data.second)
  gc (instance_data)
}

gc :: proc (instance_data: ^Two_saved_datums) {
   log.debug ("deracer gc")
   instance_data.first.reclaim (instance_data.first)
   instance_data.second.reclaim (instance_data.second)
}

instantiate :: proc (name : string) -> ^zd.Eh {
  log.debug ("! deracer instantiate")
  instance_data := new (Two_saved_datums)
  self := zd.leaf_new (name, deracer_handler, cast(^any)instance_data)
  zd.set_state (self, States.idle)
  return self
}

