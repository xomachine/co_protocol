from pipeproto import SignedRequest
from securehash import secureHash, `$`

proc sign*(request: SignedRequest): SignedRequest
proc checkSignature*(request: SignedRequest): bool

const signatureFilePath = "~/.cooperation/signature.key"

from pipeproto import serialize
from streams import newStringStream

proc sign(request: SignedRequest): SignedRequest =
  ## Signs the request.
  result = request
  result.passhash = readFile(signatureFilePath)# get it somewere
  let serialized = result.serialize()
  let signature = $secureHash(serialized)
  result.passhash = signature

proc checkSignature(request: SignedRequest): bool =
  ## Checks if request has correct signature.
  var testRequest = request
  testRequest.passhash = readFile(signatureFilePath)
  request.passhash == $secureHash(testRequest.serialize())

