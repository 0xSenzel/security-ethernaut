# Pay with less than you should

the price is obtained through external view function
```
interface Buyer {
    function price() external view returns (uint256);
}
```

We cannot have an internal state variable to change `view` (cannot write to storage) however we can make external call funtion that are marked as `view`.

`price` is fetched when `buy` is called. So we can write a contract to return value of `price` when `buy` method is called.

The new `price` is set after `isSold` is change to true so we can read the public `isSold` variable then only we return `price`.