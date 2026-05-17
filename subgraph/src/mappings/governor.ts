import { ProposalCreated, VoteCast } from "../../generated/ProtocolGovernor/ProtocolGovernor"
import { Proposal } from "../../generated/schema"
import { BigInt } from "@graphprotocol/graph-ts"

export function handleProposalCreated(event: ProposalCreated): void {
  let proposal = new Proposal(event.params.proposalId.toString())
  proposal.proposalId = event.params.proposalId
  proposal.proposer = event.params.proposer
  proposal.description = event.params.description
  proposal.startBlock = event.params.voteStart
  proposal.endBlock = event.params.voteEnd
  proposal.forVotes = BigInt.fromI32(0)
  proposal.againstVotes = BigInt.fromI32(0)
  proposal.abstainVotes = BigInt.fromI32(0)
  proposal.status = "Active"
  proposal.timestamp = event.block.timestamp
  proposal.save()
}

export function handleVoteCast(event: VoteCast): void {
  let proposal = Proposal.load(event.params.proposalId.toString())
  if (proposal == null) return

  // support: 0 = Against, 1 = For, 2 = Abstain  (GovernorCountingSimple.VoteType)
  if (event.params.support == 1) {
    proposal.forVotes = proposal.forVotes.plus(event.params.weight)
  } else if (event.params.support == 0) {
    proposal.againstVotes = proposal.againstVotes.plus(event.params.weight)
  } else {
    proposal.abstainVotes = proposal.abstainVotes.plus(event.params.weight)
  }
  proposal.save()
}
