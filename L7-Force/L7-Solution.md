# Make the balance of contract >0

Contract with no functions can still receive ETH. 
However, `transfer` or `send` will not work because this contract has no `receive` or `fallback` function.

One of the ways to bypass is through another contract's self destructs and passes the ETH to this contract.

Get the instance address:
```
contract.address
```

From Remix IDE, deposit any amount and proceed to `selfdestruct`
Verify by checking the instance address' balance:
```
getBalance(contract.address)
```
