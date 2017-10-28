from nesm import serializable

serializable:
  type
    ModuleInfo* = tuple
      name: string
      description: string
      extensions: seq[string]
      reqFields: seq[string]
      optionalFields: seq[string]

    TaskId* = distinct uint32 ## Tasks uniq number in the queue
    Pair* = tuple
      key: string
      value: string
    Task* = tuple
      name: string
      module: string ## Module to handle the task
      nprocs: uint8 ## Number of cores
      memory: uint32 ## Amount of memory in MB
      params: seq[Pair]
        ## Additional parameters such a filenames to be passed to the module

    ReqType* = enum
      Run
      Prepare
      Remove
      Status

    SignedRequest* = object
      ## For non-anonimous requests there is a way to control authorship
      ## of the request. The `SignedRequest` is the request that contains
      ## a signature in the `passhash` field. The signature is created by
      ## hashing the serialized `SignedRequest` object with the passphrase
      ## placed to `passhash` field. So the dispatcher at the server side
      ## can perform the same operation with incoming packet and the correct
      ## passphrase (which accessable to the dispatcher as soon as it running
      ## from target user) to check signature and verify the authorship of
      ## the request.
      passhash*: string
      time*: uint32
      case kind*: ReqType
      of Remove, Status:
        id*: TaskId
      of Run, Prepare:
        task*: Task
      else:
        discard

    DispatcherAnswerType* = enum
      Done ## The requested action is done (task started or stopped)
      Prepared ## The answer contains updated information about the task
      Abilities ## The list of modules provided in answer
      NotAuthorized ## The request signature does not match, so the request is
                    ## not processed.
      Error ## Other error occured. The error description attached to answer.

    Answer* = object
      ## This object is being sent in reply to `SignedRequest` from dispatcher.
      case kind*: DispatcherAnswerType
      of Error:
        description*: string
      of Abilities:
        modules*: seq[ModuleInfo]
      of Prepared:
        task*: Task
      else: discard

