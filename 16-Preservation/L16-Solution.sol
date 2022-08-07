// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Solution {
    address public timeZone1;
    address public timeZone2;
    address public owner;

    function setTime(uint256 _player) public {
        owner = address(uint160(_player));
    }
}