// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IDIDRegistry {
    struct DIDDocument {
        address controller;
        string did;
        bytes32 publicKeyHash;
        uint256 created;
        uint256 updated;
        bool deactivated;
    }

    function createDID(bytes32 publicKeyHash, string calldata did) external;
    function updateDID(bytes32 newPublicKeyHash, bytes calldata proof) external;
    function deactivateDID(bytes calldata proof) external;
    function resolveDID(string calldata did) external view returns (DIDDocument memory);
    function resolveByAddress(address user) external view returns (DIDDocument memory);
}
