Reward Vault Smart Contract

A **Clarity-based smart contract** for managing, distributing, and automating **token rewards** on the **Stacks blockchain**.  
The Reward Vault enables communities, DAOs, and staking systems to create **transparent and decentralized incentive programs**.

---

Overview

The **Reward Vault Smart Contract** provides a secure and automated way to:
- Store reward tokens in a shared vault.
- Distribute rewards fairly based on contribution or participation.
- Allow users to claim their earned rewards anytime.
- Track balances and distribution history directly on-chain.

This system ensures **fairness**, **immutability**, and **transparency** for all participants.

---

Core Features

**Vault Management** — Securely holds tokens for distribution.  
**Automated Reward Distribution** — Calculates and distributes rewards based on defined logic.  
**Claim Functionality** — Users can claim pending rewards on demand.  
**Admin Controls** — Admins can fund, configure, and manage the vault.  
**Read-Only Transparency** — Anyone can view balances and reward data.

---

Contract Functions

| Function | Type | Description |
|-----------|------|-------------|
| `deposit-rewards(amount)` | Public | Deposit tokens into the vault for future reward distribution. |
| `register-user(principal)` | Public | Register a user to be eligible for reward participation. |
| `distribute-rewards()` | Public | Distribute rewards to all registered users based on allocation logic. |
| `claim-reward()` | Public | Allow a user to claim their pending reward from the vault. |
| `get-vault-balance()` | Read-Only | Returns the total amount of tokens currently in the vault. |
| `get-user-rewards(principal)` | Read-Only | Displays pending rewards for a given user. |

---

Data Structures

- **Vault Balance:** Tracks total tokens available for rewards.  
- **User Registry:** Stores registered users eligible for reward distribution.  
- **Reward Ledger:** Maps user principals to their current reward amounts.  
- **Admin Role:** Restricts vault configuration and funding to authorized addresses.

---

Deployment (Testnet)

1. Install [Clarinet](https://docs.hiro.so/clarinet/getting-started).  
2. Clone this repository:
   ```bash
   git clone https://github.com/<your-username>/reward-vault-smart-contract.git
   cd reward-vault-smart-contract
