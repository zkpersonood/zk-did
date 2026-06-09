const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const Registry = await hre.ethers.getContractFactory("DIDRegistry");
  const registry = await Registry.deploy();
  await registry.waitForDeployment();

  console.log("DIDRegistry deployed to:", await registry.getAddress());
}

main().catch(console.error);
