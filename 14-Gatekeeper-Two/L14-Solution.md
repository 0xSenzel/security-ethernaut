# Pass Gates

## Gate One
Concept is exactly the same as Level13-GatekeeperOne. We just need to call the contract using another contract which the condition is naturally satisfied.

## Gate Two
`assembly` keyword allow us to write code in lower-level language.(Documentation)[https://docs.soliditylang.org/en/v0.6.0/assembly.html]

`caller` is an opcode that returns 20 byte address.
`extcodesize` opcode returns size of the code in the given address.
(refer here)[https://www.evm.codes/#3b]

So they will not return 0. So it is not possible to satisfy 
```
require(x == 0)
```
However from Yellow Paper:
![image](https://user-images.githubusercontent.com/62827213/183115921-99b4442e-6a83-4315-8d7b-d9133337784b.png)

So to bypass this we can simply deploy through `constructor` since it runs during initialization. Hence will return '0'.

## Gate Three
`uint64(0) - 1` means to express max number of uint64. For Solidity version 0.8.x can be express by `type(uint64).max`

So it must take the less important 8 bytes from `msg.sender`. We can cast the final output with `bytes8`.

`^` is bit wise `XOR` operation. This operation means "inverse" in summary. We can create the same effect by putting `F` to inverse the bytes we wanted to.

