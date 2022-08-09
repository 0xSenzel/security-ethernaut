# Claim contract ownership

AlienCodex is inherited from"Ownable", so to override `_owner` variable in contract's storage we have to set `contact` variable in "AlienCodex" to true as they are protected by `contacted` modifier.

Everything contract on Ethereum has storage of array 2^256 (indexing from 0 to 2^256 - 1). We noticed that from this function in "AlienCodex":
```
function retract() contacted public {
    codex.length--;
  }

```
There is a potential underflow. Initially `codex.length` is 0, we just need to invoke the `retract` method when its 0. We can change the codex length storage slot from slot 1 to slot 0 so we can gain the ability to modify any slot on the EVM storage.

To invoke `retract` first we need to call `make_contact` on console
```
contract.make_contact()
```

Then we underflow the `codex` length
```
contract.retract()
```

The storage should now looks like this:
| SLOT | DATA |
| --- | -------- |
| 0 | contact bool(1byte), owner address(20byte) | 
| 1 | codex.length | 
| // ... FROM THIS TO NOW : |
| keccak(1) | codex[0] |
| keccak(1) + 1 | codex[2] | 
| // ... |
| 2^256 - 2 | codex[2^256 - 2 - p] |
| 2^256 - 1 | codex[2^256 - 1 - p] |
| 0 | codex[2^256 - p] |

`codex` position is storage according to allocation rules is determined as `keccak256(slot)`. As we call `revise` it will offsetting with index.
```
keccak256(slot) + index
```
We know that sum of them is the size of array so:
```
2^256 = keccak(slot) + index
index = 2^256 - keccak(slot)
```
slot = 1 for the codex.length position.

We can calculate index in solidity and call the revise method to change the content of storage with `_owner`
