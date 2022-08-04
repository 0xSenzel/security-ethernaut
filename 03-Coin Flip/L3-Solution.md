# Predict outcome of coin flip 10 times in a row

Contract randomly generate coin flip result by using block number of network as seed for randomness.
```
function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue.div(FACTOR);
    bool side = coinFlip == 1 ? true : false;
...
```

Nature of blocks are deterministics and easily accessible, we can generate the result and feed to flip function.

### After Deploying the contract on Remix IDE
Get the instance address
```
contract.address()
```

### After that go back to remix and flip 10 times
We can verify the outcome:
```
contract.consecutiveWins().then(x => x.toString())
// Output: 10
```



