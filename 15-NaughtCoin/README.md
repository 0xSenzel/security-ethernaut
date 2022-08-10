# Player's token balance 0

To clear token balance we have to use `transfer` function. However the function is having a modifier `lockTokens` which player have to pass before running the `transfer` function.
```
 modifier lockTokens() {
        if (msg.sender == player) {
            require(now > timeLock);
            if (now < timeLock) {
                _;
            }
        } else {
            _;
        }
} 
```
To pass the modifier we have to bypass `msg.sender == player`. Fortunately the contract inherit [StandardToken](https://github.com/kylriley/zeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol) parent class.

Within the StandardToken.sol `transferFrom` able to transfer with the requirement `require(_value <= allowed[_from][msg.sender])`. So we only need to "allow" our player to transfer, then we can send the token to another address using `transferFrom`.

We check the balance of token player had.
```
contract.balanceOf(player).then(x => x.toString())
```

Then we approve player to transfer all the amount of coin.
```
contract.approve(player,"AMOUNT_OF_COIN")
```

Lastly we can choose a random address or contract to use `transferFrom`.
```
contract.transferFrom(player,recipient,"AMOUNT_OF_COIN")
```

