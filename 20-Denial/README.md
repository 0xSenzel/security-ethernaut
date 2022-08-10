# Denial of Service DoS

Our goal is to deny the owner from withdrawing fund when they call `withdraw` function to win this level

The contract's `withdraw` does not follow the [check-effects-interactions](https://docs.soliditylang.org/en/latest/security-considerations.html#use-the-checks-effects-interactions-pattern).
```
partner.call.value(amountToSend)("")
```
This line is susceptable to re-entrancy if we deny it to proceed next line 
```
owner.transfer(amountToSend)
```
We can make it so by stucking the execution in `call` and make code in our fallback function that can consume all the gas.