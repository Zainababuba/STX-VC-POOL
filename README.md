# STX VC Pool Smart Contract

This smart contract manages decentralized venture capital (VC) pools, allowing contributors to collectively fund and vote on investment opportunities. Designed for use with Stacks blockchain, it ensures transparency and fairness in fund management and decision-making.

## Key Features
- **Pool Creation:** Users can create decentralized VC pools to gather funds.
- **Contribution Management:** Contributors can add funds to pools, tracked on-chain.
- **Proposals:** Startups or individuals can submit funding proposals to active pools.
- **Voting System:** Contributors vote on proposals proportional to their contributions.
- **Proposal Execution:** Approved proposals result in automatic fund transfers.
- **Transparency:** All data (pools, contributions, proposals, votes) is accessible via read-only functions.

---

## Constants
- **`CONTRACT_OWNER`**: The contract's creator (default: `tx-sender`).
- **`MIN_CONTRIBUTION`**: Minimum contribution to a pool (µ100,000 microSTX).
- **`VOTING_PERIOD`**: Time allocated for voting on a proposal (~24 hours, represented as 144 blocks).
- **`PROPOSAL_THRESHOLD`**: Minimum total funds required in a pool to submit proposals (µ100,000,000 microSTX).

---

## Error Codes
- **`ERR_NOT_AUTHORIZED` (u100):** User is not authorized for the requested action.
- **`ERR_INSUFFICIENT_FUNDS` (u101):** Insufficient pool funds for the requested operation.
- **`ERR_POOL_NOT_FOUND` (u102):** Specified pool does not exist.
- **`ERR_INVALID_AMOUNT` (u103):** Invalid contribution amount (below minimum contribution).
- **`ERR_ALREADY_VOTED` (u104):** User has already voted on the proposal.
- **`ERR_VOTING_CLOSED` (u105):** Voting period for the proposal is closed.
- **`ERR_BELOW_THRESHOLD` (u106):** Pool funds are below the proposal submission threshold.

---

## Data Structures

### `pools`
- **Key:** `{ pool-id: uint }`
- **Value:**
  - `total-funds`: Total funds in the pool.
  - `active`: Pool activity status (true/false).
  - `creator`: Principal address of the pool creator.
  - `created-at`: Block height when the pool was created.

### `contributions`
- **Key:** `{ pool-id: uint, contributor: principal }`
- **Value:**
  - `amount`: Amount contributed by the user.

### `proposals`
- **Key:** `{ pool-id: uint, proposal-id: uint }`
- **Value:**
  - `startup`: Principal address of the proposal's beneficiary.
  - `amount`: Requested funding amount.
  - `description`: Brief description of the proposal (max 256 characters).
  - `votes-for`: Total votes in favor of the proposal.
  - `votes-against`: Total votes against the proposal.
  - `status`: Proposal status (`active`, `executed`, `rejected`).
  - `created-at`: Block height when the proposal was created.

### `votes`
- **Key:** `{ pool-id: uint, proposal-id: uint, voter: principal }`
- **Value:**
  - `vote`: Boolean indicating vote direction (true = for, false = against).

---

## Public Functions

### `create-pool`
Creates a new venture capital pool.
- **Returns:** New `pool-id`.

### `contribute(pool-id uint, amount uint)`
Allows users to contribute funds to a specified pool.
- **Parameters:**
  - `pool-id`: ID of the target pool.
  - `amount`: Contribution amount (must ≥ `MIN_CONTRIBUTION`).
- **Returns:** Boolean (`true` on success).
- **Notes:** Transfers STX to the contract and updates pool/contribution records.

### `submit-proposal(pool-id uint, startup principal, amount uint, description (string-utf8 256))`
Submits a funding proposal to a specified pool.
- **Parameters:**
  - `pool-id`: ID of the target pool.
  - `startup`: Address of the funding recipient.
  - `amount`: Requested amount (must ≤ `total-funds`).
  - `description`: Proposal description.
- **Returns:** New `proposal-id`.

### `vote(pool-id uint, proposal-id uint, vote-for bool)`
Allows contributors to vote on a proposal.
- **Parameters:**
  - `pool-id`: ID of the target pool.
  - `proposal-id`: ID of the proposal.
  - `vote-for`: Vote direction (`true` = for, `false` = against).
- **Returns:** Boolean (`true` on success).

### `execute-proposal(pool-id uint, proposal-id uint)`
Executes a proposal if it passes the voting process.
- **Parameters:**
  - `pool-id`: ID of the target pool.
  - `proposal-id`: ID of the proposal.
- **Returns:** Boolean (`true` = executed, `false` = rejected).
- **Notes:** Transfers approved funds to the startup if passed.

---

## Read-Only Functions

### `get-pool(pool-id uint)`
Retrieves details of a specified pool.
- **Returns:** Pool details or `none` if not found.

### `get-contribution(pool-id uint, contributor principal)`
Gets the contribution amount of a user in a specific pool.
- **Returns:** Contribution details or `none` if not found.

### `get-proposal(pool-id uint, proposal-id uint)`
Retrieves details of a specific proposal.
- **Returns:** Proposal details or `none` if not found.

### `get-vote(pool-id uint, proposal-id uint, voter principal)`
Checks whether a user has voted on a proposal.
- **Returns:** Vote details or `none` if not found.

---

## Flow Overview
1. **Create a Pool:** A user invokes `create-pool` to initialize a new venture capital pool.
2. **Contribute to Pool:** Contributors invoke `contribute` to add funds to the pool.
3. **Submit Proposal:** Once the pool meets the `PROPOSAL_THRESHOLD`, proposals can be submitted using `submit-proposal`.
4. **Vote on Proposal:** Contributors cast votes on proposals using `vote`. Voting power is proportional to contributions.
5. **Execute Proposal:** After the `VOTING_PERIOD`, proposals can be executed with `execute-proposal` based on voting results.

---

## Security Considerations
- **Authorization:** Only contributors to a pool can vote on its proposals.
- **Fund Safety:** Funds are held in the contract and only transferred after successful proposal execution.
- **Proposal Threshold:** Ensures only sufficiently funded pools can accept proposals.

---

## Future Improvements
- Add multi-signature approval for proposal submissions.
- Implement withdrawal functionality for unused contributions.
- Extend proposal description limit.

---
