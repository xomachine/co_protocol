from nesm import serializable
from pipeproto import SignedRequest, Task, TaskId


serializable:
  static:
    type
      DatagrammType* = enum
        DummyType
      Datagramm* = object
        ## Datagramms are mainly used to locate neighbour-queues which can
        ## handle the task and being transfered via UDP
        case kind*: DatagrammType
        else:
          discard

  type
    AReqType* = enum
      Abilities
      Status
   Request* = object
      ## Requests are used as initial messages in TCP sessions. Generally
      ## client or other queue sends this to queue to add or control the
      ## task.
      case anonimous*: bool
      of true:
        case sort: AReqType
        else: discard
      of false:
        author*: string
        request*: SignedRequest

    TaskState* = enum
      Enqueued
      Running
      Completed
    AckType* = enum
      Success
      Status
      Error
    Acknowledge* = object
      ## Acknowledge is an answer message that queue replies to client or
      ## another queue after receiving the `Request` message.
      case kind*: AckType
      of Error:
        reason*: string ## The text with description of the error.
      of Status:
        id*: TaskId
        task*: Task
        case state*: TaskState
        of Enqueued:
          position*: uint32
        else:
          discard
      else:
        discard

