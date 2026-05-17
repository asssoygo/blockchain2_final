// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {ProtocolTimelock} from "../src/governance/ProtocolTimelock.sol";
import {ProtocolGovernor} from "../src/governance/ProtocolGovernor.sol";
import {TreasuryV1} from "../src/treasury/TreasuryV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract Verify is Script {
    address constant TIMELOCK   = 0x630F2044d9555C3E68a1E4183C77869457f249FA;
    address constant GOVERNOR   = 0x320E10Ab8531908dEb19927612EDD82fff3E9A79;
    address constant TREASURY   = 0xdb7546b18971fc3FAb96022ee6029A267F305d03;
    address constant GOV_TOKEN  = 0x9Dc80829f5D95b8aBC89e2b2711Ce75Bfa6dDc67;
    address constant BOX        = 0xFFCE959eea953C7360f07aBB9bA042E41126021a;
    address constant DEPLOYER   = 0xaa4B652d6Fa7D5bF64Da3195F8d6A67a5C0778dc;

    function run() external view {
        console2.log("=== POST-DEPLOYMENT VERIFICATION ===");
        console2.log("");

        ProtocolTimelock timelock = ProtocolTimelock(payable(TIMELOCK));
        ProtocolGovernor governor = ProtocolGovernor(payable(GOVERNOR));
        TreasuryV1 treasury = TreasuryV1(payable(TREASURY));

        // 1. Timelock delay
        uint256 delay = timelock.getMinDelay();
        console2.log("Timelock minDelay:", delay, "seconds");
        require(delay == 2 days, "FAIL: Timelock delay != 2 days");
        console2.log("[PASS] Timelock delay = 2 days");

        // 2. Governor has PROPOSER_ROLE on Timelock
        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bool govIsProposer = timelock.hasRole(proposerRole, GOVERNOR);
        require(govIsProposer, "FAIL: Governor does not have PROPOSER_ROLE");
        console2.log("[PASS] Governor has PROPOSER_ROLE on Timelock");

        // 3. Deployer does NOT have DEFAULT_ADMIN_ROLE (revoked)
        bytes32 adminRole = timelock.DEFAULT_ADMIN_ROLE();
        bool deployerIsAdmin = timelock.hasRole(adminRole, DEPLOYER);
        require(!deployerIsAdmin, "FAIL: Deployer still has DEFAULT_ADMIN_ROLE - backdoor!");
        console2.log("[PASS] Deployer DEFAULT_ADMIN_ROLE revoked - no backdoor");

        // 4. Treasury owner = Timelock
        address treasuryOwner = treasury.owner();
        require(treasuryOwner == TIMELOCK, "FAIL: Treasury owner != Timelock");
        console2.log("[PASS] Treasury owner = Timelock");

        // 5. Governor voting parameters
        uint256 votingDelay  = governor.votingDelay();
        uint256 votingPeriod = governor.votingPeriod();
        uint256 threshold    = governor.proposalThreshold();
        uint256 quorum       = governor.quorumNumerator();

        console2.log("Governor votingDelay:", votingDelay, "blocks");
        console2.log("Governor votingPeriod:", votingPeriod, "blocks");
        console2.log("Governor proposalThreshold:", threshold);
        console2.log("Governor quorumNumerator:", quorum, "%");

        require(quorum == 4, "FAIL: quorum != 4%");
        console2.log("[PASS] Quorum = 4%");

        require(threshold == 1_000e18, "FAIL: proposalThreshold != 1000 GT");
        console2.log("[PASS] ProposalThreshold = 1000 GT (1%)");

        console2.log("");
        console2.log("=== ALL CHECKS PASSED ===");
        console2.log("Protocol is correctly configured.");
        console2.log("No admin backdoors detected.");
    }
}