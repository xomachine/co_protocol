import jsonhelper
export jsonhelper
from pipeproto import Task, ModuleInfo

type
  InitMessage* = ModuleInfo
  TaskMessage* = tuple
    action: string
    task: Task

