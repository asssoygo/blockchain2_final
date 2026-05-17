import { DepositWithReceipt } from "../../generated/YieldVault/YieldVault"
import { VaultDeposit } from "../../generated/schema"
import { BigInt } from "@graphprotocol/graph-ts"

export function handleDeposit(event: DepositWithReceipt): void {
  let id = event.transaction.hash.toHexString() + "-" + event.logIndex.toString()
  let deposit = new VaultDeposit(id)
  deposit.caller = event.params.caller
  deposit.receiver = event.params.receiver
  deposit.assets = event.params.assets
  deposit.shares = event.params.shares
  deposit.timestamp = event.block.timestamp
  deposit.blockNumber = event.block.number
  deposit.save()
}
