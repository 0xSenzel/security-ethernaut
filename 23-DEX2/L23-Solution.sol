// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/ERC20.sol";

contract Solution is ERC20 {
    constructor (uint256 initialSupply) public ERC20("BadToken", "BAD") {
         _mint(msg.sender, initialSupply);
    }
}