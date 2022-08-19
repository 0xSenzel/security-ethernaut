// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

contract Solution {

    function kill() public {
        selfdestruct(address(0));
    }
}