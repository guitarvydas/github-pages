Newbie: I'm arguing with the Odin compiler on (hopefully) a syntactic issue.  I want to create a variable that is accessible to several procedures and set its value in one of the procedures.  Like a static var with file scope in C.
```
...
States :: enum {idle, waitingForFirst, waitingForSecond}
state : States = .idle
...
sequential_send :: proc {
  state = .idle
...
}
...
```

next: I'm going to need to know more about allocation/allocators freeing vs. deleting vs. strings.  Where can I read/learn about this?
