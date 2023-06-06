package deracer

import "core:fmt"
import "core:os"
import "core:mem"
import zd "../../odin0d/0d"


States :: enum {idle, waitingForFirst, waitingForSecond}

Two_saved_messages :: struct {
  first : zd.Message,
  second : zd.Message
}

deracer_handler :: proc(eh: ^zd.Eh, message: zd.Message, instance_data: ^Two_saved_messages) {
  fmt.println ("@@@ deracer", eh.state, message)
  // this is a clumsy first-cut implementation ; this version saves the whole message, but
  // we don't actually need to save the port, it's just easier to clone the whole message (including
  // the port) instead of peeling the data out and cloning the data only.  In fact, if the 0D runtime
  // clones the message anyway, making each message unique, then maybe we don't need to clone the
  // message again here - we just need to stop the runtime from GC'ing the already-cloned message
  // until we say that it needs to be GC'ed
  switch transmute(States)eh.state {
    case .idle:
      switch message.port {
        case "in_first":
          instance_data.first = zd.message_clone (message)
          zd.set_state (eh, States.waitingForSecond)
        case "in_second":
          instance_data.second = zd.message_clone (message)
          zd.set_state (eh, States.waitingForFirst)
        case:
          zd.send (eh, "error", "sequencing error A")
      }
      fmt.println ("+++ deracer", eh.state)
    case .waitingForSecond:
      switch message.port {
        case "in_second":
          instance_data.second = zd.message_clone (message)
          sequential_send (eh, instance_data)
        case : zd.send (eh, "error", "sequencing error B")
      }
    case .waitingForFirst:
      switch message.port {
        case "in_first":
          instance_data.first = zd.message_clone (message)
          sequential_send (eh, instance_data)
        case : zd.send (eh, "error", "sequencing error C")
      }
   }
}

sequential_send :: proc (eh: ^zd.Eh, instance_data: ^Two_saved_messages) {
  zd.set_state (eh, States.idle)
  zd.send (eh, "first", instance_data.first)
  zd.send (eh, "second", instance_data.second)
  gc (instance_data)
}

gc :: proc (instance_data: ^Two_saved_messages) {
  zd.destroy_message (instance_data.first)
  zd.destroy_message (instance_data.second)
}

instantiate :: proc (name : string) -> ^zd.Eh {
  fmt.println ("*** deracer instantiate")
  instance_data := new (Two_saved_messages)
  self := zd.make_leaf(name, instance_data, deracer_handler)
  zd.set_state (self, States.idle)
  return self
}

