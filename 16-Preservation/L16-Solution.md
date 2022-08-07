# Take over contract ownership

`delegatecall` will call the `setTime` function inside contract "LibraryContract". 

When "LibraryContract" executed `setTime` it will modify storage slot 0 of "Preservation" contract because it modifies slot 0 at "LibraryContract".

slot number | LibraryContract | Preservation|
slot 0 | storedTime | timeZone1Library
slot 1 | - | timeZone2Library
slot 2 | - | owner
slot 3 | - | storedTime

So in this case, the function actually modifies slot 0. Hence we can exploit it by updating the variable in slot 0 with our mallicious contract and when calling it again the contract can update slot 2 variable.

Update slot 0 with our contract
```
contract.setFirstTime("DEPLOYED_CONTRACT_ADDRESS")
```

execute the function to call our contract and change ownership
```
contract.setFirstTime(player)
```

