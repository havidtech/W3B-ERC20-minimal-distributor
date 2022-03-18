//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";


contract ERC20WithClaims is ERC20, Ownable {

    uint private constant maxSupply = 1000000 * 10 ** 18;
    bytes32 private constant claimsMerkleRoot = 0xbe77491a8bd0a1fbe7eb5592b24bee45d7cd0d4f987b4b9c9d549ed3fce6eaf6;
    mapping(address => bool) receivedClaim;

    constructor () ERC20("ERC20WithClaims", "ERC20WC"){}

    function buyToken(address reciever) public payable {
        require(msg.value > 0, "You didn't provide any ether");
        require(maxSupplyNotReached(msg.value), "Total Supply limit Reached");
        _mint(reciever, msg.value);

        withdrawPayment();
    }

    function maxSupplyNotReached(uint amount) internal view returns (bool) {
        return amount + totalSupply() <= maxSupply;
    }

    function withdrawPayment() internal {
        (bool sent, bytes memory data) = payable(owner()).call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }

    function claimToken(uint amount) public {
        require(!receivedClaim[msg.sender], "You have already claimed tokens");
        require(maxSupplyNotReached(amount), "Too late! You should have claimed earlier");
        
        // Check claim validity
        bytes32 claimMerkleLeaf = keccak256(abi.encodePacked(msg.sender, amount));
        bytes32[] memory proof;
        require(MerkleProof.verify(proof, claimsMerkleRoot, claimMerkleLeaf), "Invalid Claim!");
        
        receivedClaim[msg.sender] = true;
        _mint(msg.sender, amount);
        
    }
}