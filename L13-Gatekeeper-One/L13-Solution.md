# Pass the gates

## Gate 1
 From solidity docs about [global variables](https://docs.soliditylang.org/en/latest/cheatsheet.html?#global-variables) :

 - `msg.sender` : sender of the message (current call)
 - `tx.origin` : sender of the transaction

 To fulfill the requirement we only need to call the contract using another contract so:
 `msg.sender` = our metamask address
 `tx.origin` = our deployed contract address

 ## Gate 2
 `mod(8191)` means that the gas number must be the multiplication of 8191.
 We can brute force the function by putting a gas number that is high and definitely enough and make a range of 8191. The number must be within range of 8191.

 ## Gate 3
 Condition 1:
 ```
uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)
 ```
 let tx.origin be 0x37f2BD3F66D680acE396f9EAB894be824E7d9B2F which is player's address. Since the function take bytes8 only, we fix every _gateKey to bytes8

To let:
 - uint32(0xB894be824E7d9B2F) == uint16(0xB894be824E7d9B2F)
 - 0x000000004E7d9B2F == 0x0000000000009B2F
 This is only possible when we mask 0x000000004E7d9B2F with 0x000000000000FFFF
 _gateKey = 0x0000000000009B2F
 To get the same result from bytes8(uint32(_gateKey)) to 0x0000000000009B2F. we can do bytes8(uint32(bytes8(tx.origin) & 0xFFFFFFFF0000FFFF masking

| Parameter | Result |
| -------- | -------- | 
|bytes8(_gateKey) |`0xB894be824E7d9B2F`|
|bytes8(uint16(_gateKey)) | `0x0000000000009B2F` |
|bytes8(uint32(_gateKey)) | `0x000000004E7d9B2F` |
|bytes8(uint32(bytes8(tx.origin) & 0xFFFFFFFF0000FFFF))| `0x0000000000009B2F` |


Condition 2:
 ```
uint32(uint64(_gateKey)) != uint64(_gateKey)
 ```
 - 0x000000004E7d9B2F != 0xB894be824E7d9B2F
Result already satisfied, but to cater with condition 1, we can use the masking from condition 1.

```
uint32(uint64(_gateKey)) == uint16(tx.origin)
```
- 0x000000004E7d9B2F == 0x0000000000009B2F
To satisfy this statement we can mask uint32(uint64(_gateKey)) with 0xFFFFFFFF0000FFFF

To summarize we take bytes8(tx.origin) and then mask it with 0xFFFFFFFF0000FFFF we can also get 0x0000000000009B2F in the end.