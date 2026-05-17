# DeFi Super-App Subgraph

Indexes events from the DeFi Super-App protocol on **Arbitrum Sepolia** (Chain ID 421614).

## Entities

| Entity | Source | Description |
|---|---|---|
| `Token` | GovernanceToken | Global supply, holder count, delegation count |
| `Swap` | AMM pairs | Individual swap events with amounts in/out |
| `VaultDeposit` | YieldVault | ERC-4626 deposit receipts |
| `Proposal` | ProtocolGovernor | Governance proposals with live vote tallies |

## Contract Addresses (Arbitrum Sepolia)

| Contract | Address |
|---|---|
| GovernanceToken | `0x9Dc80829f5D95b8aBC89e2b2711Ce75Bfa6dDc67` |
| YieldVault | `0x10C38C37455084Bb060d7c385145b6039F99bb6b` |
| ProtocolGovernor | `0x320E10Ab8531908dEb19927612EDD82fff3E9A79` |
| AMMFactory | `0xFD24fd97BD869819Dc77bc4bB92F28E8C3687353` |

## Deploy to Goldsky

```bash
# 1. Install the Goldsky CLI (once)
npm install -g @goldsky/cli

# 2. Authenticate
goldsky login

# 3. Install subgraph dependencies
npm install

# 4. Generate TypeScript types from schema + ABIs
npm run codegen

# 5. Build WASM mappings
npm run build

# 6. Deploy
npm run deploy:goldsky
```

## GraphQL Endpoint

After deployment:
```
https://api.goldsky.com/api/public/project_xxx/subgraphs/defi-superapp/1.0.0/gn
```

Replace `project_xxx` with your Goldsky project ID shown after `goldsky login`.

## Example Queries

See `queries.graphql` for 5 documented queries:

1. **GetTokenStats** — global governance token metrics
2. **GetRecentSwaps** — last 10 AMM swaps across all pairs
3. **GetUserDeposits** — vault deposit history for a specific address
4. **GetActiveProposals** — open proposals with vote counts
5. **GetAllProposals** — full proposal history with status
