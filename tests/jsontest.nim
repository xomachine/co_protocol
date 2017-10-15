import co_protocol.modproto
import unittest

suite "Modproto":
  test "InitMessage serialization":
    var m: InitMessage
    m.name = "test"
    m.description = "testtest"
    m.extensions = newSeq[string]()
    m.reqFields = @["file"]
    m.optionalFields = newSeq[string]()
    let serialized = $m.toJson()
    let deserialized = parseJson(serialized)
    var dm: InitMessage
    dm.fromJson(deserialized)
    check(dm == m)

  test "TaskMessage serialization":
    var tm: TaskMessage
    tm.action = "testaction"
    tm.task.name = "test"
    tm.task.module = "tmodule"
    tm.task.params = @[(key: "file", value: "testfile")]
    let serialized = $tm.toJson()
    let deserialized = parseJson(serialized)
    var dtm: TaskMessage
    dtm.fromJson(deserialized)
    check(dtm == tm)
