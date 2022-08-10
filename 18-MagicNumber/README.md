# Build smart contract functionality with byte code

Challenge require us to create smart contract with a  runtime opcode size of not more than 10 opcodes(10 bytes). Even if we create and deploy smart contract with no function the code will be about 63 bytes.

When smart contract is compiled, it will be translated into bytecode. The bytecode is formed by 2 segment. 
* Initialization opcode
* Runtime opcode

### Runtime opcode
Our goal is to return '42' (0x2a in hex). 
For many creation of smart contract, the [magic number](https://medium.com/@blockchain101/solidity-bytecode-and-opcode-basics-672e9b1a88c2)(bytecode) is *6060604052*. For our opcode it would be needing:
| OPCODE | BYTECODE | NAME | DETAIL |
| ---- | ---- | ---- | ---------- |
| 0X60 | 602a | PUSH 1 | push 0x2a in stack |
| 0x52 | 52 | MSTORE | store value, position |
| 0xf3 | f3 | RETURN | return value, size |

MSTORE would be needing value and position, so we run PUSH value and PUSH position before MSTORE. Next we need to return the value which would be needing PUSH value and PUSH size. So our corresponding opcodes:
 ```
OPCODE      DETAIL
--------------------------
602a        Push "42" in hex
6050        Push 0x50
52          Store 0x2a value, 0x50 position in memory
6020        Push 0x20 size for RETURN
6050        Push 0x50 slot at which 0x2a is stored
f3          RETURN value 0x2a and size 0x20 (32bytes)
 ```
 Concatenate the opcodes we get bytecode:
 `602a60505260206050f3`

### Initialization opcode
It replicates runtime opcode, return them to EVM. This functio is handled by opcode `codecopy`. This opcode takes 3 arguments:
* Destination position of code
* current position of runtime opcode (in reference to entire bytecore)
* size of the code in byte
For our opcode it would be needing:

| OPCODE | BYTECODE | NAME |
| ---- | ---- | ---- |
| 0X60 | 6000 | PUSH 1 |
| 0xf3 | f3 | RETURN |
| 0x39 | 39 | CODECOPY |


 ```
OPCODE      DETAIL
--------------------------
600a        Push 10 bytes (size of runtime opcode)
60--        Push -- (current position of runtime opcode)
6000        Push 0x00 (destination in memory)
39          Copy code of size 0x0a, to destination 0x--, in 0x00 memory
600a        Push again size for RETURN
6000        Push again position for RETURN
f3          RETURN value 0x0a and size 0x--
 ```
Concatenate the opcodes we get bytecode:
 `600a60--600039600a6000f3`
 
 Total is 12 bytes, so position of runtime opcode is 12 or "0x0c" in hex. Therefore the final bytecode:
 `600a600c600039600a6000f3`

### Final Opcode
```
initialization opcode + runtime opcode

=   600a600c600039600a6000f3 + 602a60505260206050f3

=   600a600c600039600a6000f3602a60505260206050f3
```

Now we send the number to contract
```
bytecode = '600a600c600039600a6000f3602a60505260206050f3'

txn = await web3.eth.sendTransaction({from: player, data: bytecode})
```

After sending we call `solverAddr` function to set the number
```
solverAddr = txn.contractAddress
contract.setSolver(solverAddr)
```