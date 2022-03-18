/* eslint-disable node/no-missing-import */
/* eslint-disable no-undef */
import { ethers } from "hardhat";

async function deployERC20WithClaims() {
  // We get the contract to deploy
  const ERC20WithClaims = await ethers.getContractFactory("ERC20WithClaims");
  const token = await ERC20WithClaims.deploy();

  await token.deployed();

  console.log("ERC20WithClaims deployed to:", token.address);
}

deployERC20WithClaims().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
