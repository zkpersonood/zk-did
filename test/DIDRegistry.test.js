const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DIDRegistry", function () {
  let registry, owner;

  beforeEach(async function () {
    [owner] = await ethers.getSigners();
    const Registry = await ethers.getContractFactory("DIDRegistry");
    registry = await Registry.deploy();
    await registry.waitForDeployment();
  });

  it("should create a DID", async function () {
    const did = "did:zk:" + owner.address.toLowerCase().substring(2, 10);
    const keyHash = ethers.keccak256(ethers.toUtf8Bytes("public-key"));

    await expect(registry.createDID(keyHash, did))
      .to.emit(registry, "DIDCreated");

    const doc = await registry.resolveDID(did);
    expect(doc.controller).to.equal(owner.address);
    expect(doc.deactivated).to.equal(false);
  });
});
