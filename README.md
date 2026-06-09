# ZK DID

A decentralized identity (DID) registry with zero-knowledge privacy. Create, update, and resolve DIDs on-chain.

## Contracts

- **DIDRegistry.sol** — Complete DID lifecycle management: create, update, deactivate, and resolve
- **DIDResolver.sol** — Utility contract for verifying DID control and querying metadata

## DID Method

Uses the `did:zk:` method prefix. Each DID is controlled by an Ethereum address and secured with public key cryptography.

## Getting Started

```bash
npm install
npx hardhat compile
npx hardhat test
```

## Deploy

```bash
npx hardhat run scripts/deploy.js --network sepolia
```
