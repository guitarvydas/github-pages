package deracer

import "core:fmt"
import "core:os"
import zd "../../odin0d/0d"

@(private="file") first : string
@(private="file") second : string
States :: enum {idle, waitingForFirst, waitingForSecond}
@(private="file") state : States = .idle

deracer_handler :: proc(eh: ^zd.Eh, message: zd.Message(string)) {
  fmt.println (">>> deracer", state, message)
  switch state {
    case .idle:
      switch message.port {
        case "first":
	  first = message.datum
	  state = .waitingForSecond
        case "second":
	  second = message.datum
	  state = .waitingForFirst
        case:
	  zd.send (eh, "error", "sequencing error A")
      }
      fmt.println ("+++ deracer", state)
    case .waitingForSecond:
      switch message.port {
	case "second":
	  second = message.datum
	  sequential_send (eh)
	case : zd.send (eh, "error", "sequencing error B")
      }
    case .waitingForFirst:
      switch message.port {
        case "first":
	  first = message.datum
	  sequential_send (eh)
	case : zd.send (eh, "error", "sequencing error C")
      }
   }
}

sequential_send :: proc (eh: ^zd.Eh) {
  state = .idle
  zd.send (eh, "first", first)
  zd.send (eh, "second", second)
  gc ()
}

gc :: proc () {
  delete (first)
  delete (second)
}

instantiate :: proc (name : string) -> (^zd.Eh) {
  fmt.println ("*** deracer instantiate")
  return zd.make_leaf(name, deracer_handler)
}

