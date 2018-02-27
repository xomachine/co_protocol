from md5 import MD5Digest
from nesm import serializable, toSerializable
from pipeproto import SignedRequest, Task, TaskId, ModuleInfo, ReqType, Pair

toSerializable(MD5Digest, dynamic: false)

serializable:
  static:
    type
      NodeStatus* = enum
        Free
        Filled
      DatagrammType* = enum
        Discover ## A broadcast request for nodes to show themselfs up
        DiscoverReply ## Nodes replies with this to `Discover` request
        FindOwner ## A broadcast request for node that currently holding task
                  ## with given `TaskId`
        OwnerFound ## The node that holds the requested task will answer with
                   ## this
      Datagramm* = object
        ## Datagramms are mainly used to locate neighbour-queues which can
        ## handle the task and being transfered via UDP
        case kind*: DatagrammType
        of FindOwner:
          task: TaskId
        of DiscoverReply:
          status: NodeStatus
          procsAvailable: uint8
          memoryAvailable: uint32
          abilitiesHash: MD5Digest
        else:
          discard

  type
    AReqType* = enum
      Abilities ## Request for detailed list of modules supported by a node
      QueueStatus ## Request for list of tasks the node is holding
    TaskDescription* = tuple
      name: string
      author: uint32
      module: string
    Request* = object
      ## Requests are used as initial messages in TCP sessions. Generally
      ## client or other queue sends this to queue to add or control the
      ## task.
      case anonimous*: bool
      of true:
        case sort*: AReqType
        of Abilities:
          modules*: seq[ModuleInfo]
        of QueueStatus:
          enqueued*: seq[TaskDescription]
          running*: seq[TaskDescription]
          completed*: seq[TaskDescription]
        else: discard
      of false:
        author*: uint32
        request*: SignedRequest

    TaskState* = enum
      Enqueued
      Running
      Completed
    ReplyType* = enum
      ActionDone
      TaskStatus
      ErrorOccured
    Reply* = object
      ## Acknowledge is an answer message that queue replies to client or
      ## another queue after receiving the `Request` message.
      case kind*: ReplyType
      of ErrorOccured:
        reason*: string ## The text with description of the error.
      of TaskStatus:
        id*: TaskId
        task*: Task
        case state*: TaskState
        of Enqueued:
          position*: uint32
        else:
          discard
      else:
        discard

