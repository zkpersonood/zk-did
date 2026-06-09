# ZK DID — Decentralized Identity with Zero-Knowledge Privacy

A decentralized identifier (DID) registry built for the `did:zk:` method. Create, update, resolve, and deactivate DIDs entirely on-chain with privacy-preserving features.

## Overview

This protocol implements a complete **DID lifecycle** on Ethereum using a `did:zk:` method that supports:

- **Self-sovereign identity** — Users control their own DIDs without centralized registries
- **Key rotation** — Update public keys associated with a DID without losing identity history
- **Deactivation** — Deactivate compromised DIDs with proof of ownership
- **Privacy** — DID documents can be resolved without exposing unnecessary information

### DID Format

```
did:zk:<ethereum-address-prefix>-<checksum>
```

Example: `did:zk:0xabcd...1234-a1b2c3d4`

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                     DIDRegistry                            │
├──────────────────────────────────────────────────────────┤
│ DID Document Structure:                                   │
│ · controller — Ethereum address that controls the DID    │
│ · did — full DID string                                   │
│ · publicKeyHash — hash of the associated public key      │
│ · created — timestamp of creation                         │
│ · updated — timestamp of last update                      │
│ · deactivated — boolean flag                              │
├──────────────────────────────────────────────────────────┤
│ + createDID(publicKeyHash, did)                           │
│ + updateDID(newPublicKeyHash, proof)                     │
│ + deactivateDID(proof)                                    │
│ + resolveDID(did) → DIDDocument                          │
│ + resolveByAddress(user) → DIDDocument                   │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│                     DIDResolver                            │
├──────────────────────────────────────────────────────────┤
│ Utility contract for common DID operations:               │
│ · verifyControl(did, controller) → bool                 │
│ · getDIDAge(did) → uint256                              │
└──────────────────────────────────────────────────────────┘
```

## Contracts

| Contract | Description |
|----------|-------------|
| **DIDRegistry.sol** | Core contract — manages the complete DID lifecycle including creation, update, deactivation, and resolution |
| **DIDResolver.sol** | Utility contract — helper functions for DID control verification and metadata queries |

## DID Lifecycle

### Create

```
User generates keypair → computes publicKeyHash
  → creates DID string → registers on-chain
  → DIDDocument stored with controller, timestamps
```

### Update

```
User generates new keypair → prepares update proof
  → submits to registry → publicKeyHash updated
  → updated timestamp refreshed
```

### Deactivate

```
User prepares deactivation proof
  → submits to registry → deactivated flag set to true
  → All future resolves return deactivated status
```

### Resolve

```
Anyone can resolve a DID document by:
  · DID string → resolveDID("did:zk:...")
  · Ethereum address → resolveByAddress(0x...)
```

## Getting Started

### Installation

```bash
git clone https://github.com/zkpersonood/zk-did.git
cd zk-did
npm install
npx hardhat compile
npx hardhat test
```

### Usage Example

```javascript
// Create a DID
const did = "did:zk:" + wallet.address.toLowerCase().substring(2, 10);
const keyHash = ethers.keccak256(ethers.toUtf8Bytes("my-public-key"));
await registry.createDID(keyHash, did);

// Resolve a DID
const doc = await registry.resolveDID(did);
console.log(doc.controller); // 0x...
console.log(doc.created);    // timestamp
```

### Deploy

```bash
npx hardhat run scripts/deploy.js --network sepolia
```

## W3C DID Core Compliance

This implementation follows the [W3C DID Core 1.0](https://www.w3.org/TR/did-core/) specification:

- ✅ DID method: `did:zk:`
- ✅ DID document structure with controller
- ✅ Key management and rotation
- ✅ Deactivation support
- ✅ CRUD operations (Create, Read, Update, Deactivate)

## Applications

- **Verifiable Credentials** — DIDs as the foundation for VC subjects and issuers
- **Authentication** — DID-based login for dApps
- **Reputation** — Portable reputation across platforms
- **Key Management** — Rotate keys without breaking identity
- **Interoperability** — Compatible with W3C standards for cross-platform identity

## License

MIT
