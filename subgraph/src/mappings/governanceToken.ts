import { Transfer, DelegateChanged } from "../../generated/GovernanceToken/GovernanceToken"
import { Token } from "../../generated/schema"
import { BigInt, Bytes } from "@graphprotocol/graph-ts"

function loadOrCreateToken(): Token {
  let token = Token.load("1")
  if (token == null) {
    token = new Token("1")
    token.totalSupply = BigInt.fromI32(0)
    token.totalHolders = BigInt.fromI32(0)
    token.totalDelegated = BigInt.fromI32(0)
  }
  return token
}

export function handleTransfer(event: Transfer): void {
  let token = loadOrCreateToken()

  // Mint: from == address(0)
  if (event.params.from == Bytes.fromHexString("0x0000000000000000000000000000000000000000")) {
    token.totalSupply = token.totalSupply.plus(event.params.value)
    token.totalHolders = token.totalHolders.plus(BigInt.fromI32(1))
  }

  // Burn: to == address(0)
  if (event.params.to == Bytes.fromHexString("0x0000000000000000000000000000000000000000")) {
    token.totalSupply = token.totalSupply.minus(event.params.value)
  }

  token.save()
}

export function handleDelegateChanged(event: DelegateChanged): void {
  let token = loadOrCreateToken()
  token.totalDelegated = token.totalDelegated.plus(BigInt.fromI32(1))
  token.save()
}
