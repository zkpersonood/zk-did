// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IDIDRegistry.sol";

contract DIDResolver {
    IDIDRegistry public registry;

    constructor(address registryAddress) {
        registry = IDIDRegistry(registryAddress);
    }

    function verifyControl(string calldata did, address claimedController) external view returns (bool) {
        IDIDRegistry.DIDDocument memory doc = registry.resolveDID(did);
        return doc.controller == claimedController && !doc.deactivated;
    }

    function getDIDAge(string calldata did) external view returns (uint256) {
        IDIDRegistry.DIDDocument memory doc = registry.resolveDID(did);
        return block.timestamp - doc.created;
    }
}
