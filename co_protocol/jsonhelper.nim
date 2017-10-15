from pipeproto import Pair
import jser
export jser

proc toJson*(t: seq[Pair], flags = DefaultSerializerFlags): JsonNode =
  result = newJObject()
  for p in t:
    result[p.key] = toJson(p.value, flags)

proc fromJson*(t: var seq[Pair], j: JsonNode, flags = DefaultDeserializerFlags) =
  assert(j.kind == JObject, $j & " is not a seq[Pair]")
  if t.isNil:
    t = newSeq[Pair]()
  for k, v in j.pairs():
    t.add((key: k, value: v.getStr))

proc toJson*(t: SomeUnsignedInt, flags = DefaultSerializerFlags): JsonNode =
  toJson(t.BiggestInt, flags)
proc fromJson*(t: var SomeUnsignedInt, j: JsonNode, flags = DefaultDeserializerFlags) =
  var tt: BiggestInt
  fromJson(tt, j, flags)
  t = tt.SomeUnsignedInt
