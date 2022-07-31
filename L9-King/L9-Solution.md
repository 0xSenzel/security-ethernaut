# Send more ETH than the current prize and stay the king

Our goal is not the be the king but to stop other ppl to call this line:
```
king.transfer(msg.value)
```

Through the line we noticed that `king` is sent back `msg.value`, so what if the previous `king` is a contract and do not have any `receive` or `fallback`

First we check the prize pool amount
```
contract.prize().then(x => x.toString())
// Output: 1000000000000000
```

We have to send > 1000000000000000 wei to let our contract take over kingship. Get instance address and start the attack through remix ide
```
contract.address
```

Upon reaching the `king.transfer(msg.value)` it will not have any specifying payable fallback function and we will be king forever.