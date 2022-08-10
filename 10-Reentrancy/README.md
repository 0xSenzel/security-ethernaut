# Empty the contract fund
## Checks-Effects-Interactions Pattern

We get the instance address and deploy with remix ide of target contract
Once the contract is deployed, we call `donateAndWithdraw`.

- At first `targetContract.donate.value(msg.value)(address(this))` will cause `balances[msg.sender]` to donate an amount set through remix ide.

- `targetContract.withdraw(msg.value)` invokes withdraw and send the amount back

- `receive`invokes again to withdraw however `withdraw` is still ongoing, so this continues until the target contract is empty.
