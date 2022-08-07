# Recover lost fund from unknown contract address

By the deterministic of blockchain, the contract address can be predicted according to Yellow Paper:

>The address of the new account is defined as being the rightmost 160 bits of the Keccak-256 hash of the RLP encoding of the structure containing only the sender and the account nonce. Thus we define the resultant address for the new account a ≡ B96..255 KEC RLP (s, σ[s]n − 1)

or: 
```
address = rightmost_20_bytes(keccak(RLP(sender address, nonce)))
```

where:
* sender_address: contract / wallet created this contract
* nonce: number of transactions sent from sender_address / if sender is a factory contract, the nonce is the number of contrac-creations made by this account
* RLP: encoder on data structure
* keccak: cryptographic primitive that compute the Ethereum-SHA-3 (Keccak-256) hash of any input

[From the help of our fellow buddies.](https://ethereum.stackexchange.com/questions/760/how-is-the-address-of-an-ethereum-contract-computed/761#761)

We can find the lost contract address using this in console.
```
web3.utils.soliditySha3(
  '0xd6',
  '0x94',
  'YOUR_LEVEL_INSTANCE_ADDRESS',
  '0x01'
)
```
The last 20 bytes of the output result will be the contract address. Call the destroy function through remix ide and input the address.
