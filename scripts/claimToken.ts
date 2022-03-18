/* eslint-disable node/no-missing-import */
/* eslint-disable no-undef */
import { ethers } from "hardhat";
import { ERC20WithClaims } from "../typechain/ERC20WithClaims";

async function mintNft() {
  // We get the contract to deploy
  const tokenAddress = "0x9e666AbB28B8C4D889D64d3Ba55E889eCAdc4562";
  const token = (await ethers.getContractAt(
    "ERC20WithClaims",
    tokenAddress
  )) as ERC20WithClaims;

  await token.claimToken("8000000000000000000");

  console.log(
    "My Balance is => ",
    await token.balanceOf("0x97542289b1453eB8e9C0f4af562ef7eb354DB75c")
  );
}

mintNft().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
