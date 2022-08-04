# Take over ownership of contract

To claim contract's ownership, we need to make tx.origin different from msg.sender
```
if (tx.origin != msg.sender) {
      owner = _owner;
    }
```

tx.origin always refers to the original external account that sent transaction. However, msg.sender refers to the address that send transaction.

We can create a proxy contract to simply call `Telephone` to change ownership