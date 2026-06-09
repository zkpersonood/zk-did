// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IDIDRegistry.sol";

contract DIDRegistry is IDIDRegistry {
    mapping(string => DIDDocument) private documents;
    mapping(address => string) private addressToDID;
    string[] private didList;

    event DIDCreated(string indexed did, address indexed controller);
    event DIDUpdated(string indexed did);
    event DIDDeactivated(string indexed did);

    function createDID(bytes32 publicKeyHash, string calldata did) external override {
        require(bytes(documents[did].did).length == 0, "DID already exists");
        require(bytes(addressToDID[msg.sender]).length == 0, "Already has DID");

        documents[did] = DIDDocument({
            controller: msg.sender,
            did: did,
            publicKeyHash: publicKeyHash,
            created: block.timestamp,
            updated: block.timestamp,
            deactivated: false
        });

        addressToDID[msg.sender] = did;
        didList.push(did);
        emit DIDCreated(did, msg.sender);
    }

    function updateDID(bytes32 newPublicKeyHash, bytes calldata proof) external override {
        string memory did = addressToDID[msg.sender];
        require(bytes(did).length > 0, "No DID");
        require(!documents[did].deactivated, "DID deactivated");
        require(verifyOwnership(did, proof), "Invalid proof");

        documents[did].publicKeyHash = newPublicKeyHash;
        documents[did].updated = block.timestamp;
        emit DIDUpdated(did);
    }

    function deactivateDID(bytes calldata proof) external override {
        string memory did = addressToDID[msg.sender];
        require(bytes(did).length > 0, "No DID");
        require(verifyOwnership(did, proof), "Invalid proof");

        documents[did].deactivated = true;
        documents[did].updated = block.timestamp;
        emit DIDDeactivated(did);
    }

    function resolveDID(string calldata did) external view override returns (DIDDocument memory) {
        require(bytes(documents[did].did).length > 0, "DID not found");
        return documents[did];
    }

    function resolveByAddress(address user) external view override returns (DIDDocument memory) {
        string memory did = addressToDID[user];
        require(bytes(did).length > 0, "No DID for address");
        return documents[did];
    }

    function verifyOwnership(string memory did, bytes memory proof) internal view returns (bool) {
        return proof.length >= 32;
    }

    function getDIDCount() external view returns (uint256) {
        return didList.length;
    }
}
