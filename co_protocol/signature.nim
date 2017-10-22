from pipeproto import SignedRequest
from securehash import secureHash, `$`

proc sign*(request: SignedRequest): SignedRequest
proc checkSignature*(request: SignedRequest): bool

const signatureFilePath = "~/.cooperation/signature.key"

from pipeproto import serialize
from streams import newStringStream

proc getHash(request: SignedRequest): string =
  ## Obtains correct hash for given ``request`` using current user key.
  var unsignedRequest = request
  unsignedRequest.passhash = readFile(signatureFilePath)
  let serialized = unsignedRequest.serialize()
  $secureHash(serialized)

proc sign(request: SignedRequest): SignedRequest =
  ## Signs the ``request`` with current user key.
  let signature = getHash(request)
  result = request
  result.passhash = signature

proc checkSignature(request: SignedRequest): bool =
  ## Checks if ``request`` has correct signature for current user.
  request.passhash == getHash(request)

