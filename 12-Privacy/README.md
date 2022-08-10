# Change `locked` state to `false`

State variables are stored in slots.
- `locked` is bool (1 byte) stored in slot 0
- `ID` is uint256 (32 byte) so it fully filled slot 1
- `flattening` is uint8 (1 byte) , `denomination` is uint8 (1 byte), `awkwardness` is uint16 (2 byte) all 3 will fill slot 2

Array will always start new slot. Since 32 bytes will take 1 entire slot.
- data[0] in slot 3
- data[1] in slot 4
- data[2] in slot 5

We now know our key is in slot 5 so we can acquire by:
```
key = web3.eth.getStorageAt(contract.address, 5)
```

We deploy our remix ide contract with instance address.
After acquiring the key we copy the output and paste it on `unlock` function.

Verify
```
contract.locked()
// Output: False
```