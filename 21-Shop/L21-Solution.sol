// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IShop {
    function buy() external;
    function isSold() external view returns (bool);
    function price() external view returns (uint);
}

contract Solution {
    function price() external view returns (uint) {
        bool isSold = IShop(msg.sender).isSold();
        uint askPrice = IShop(msg.sender).price();

        if (!isSold) {
            return askPrice;
        }

        return 0;
    }

    function buyItem(address _instanceAddy) public {
        IShop(_instanceAddy).buy();
    }
}