# TD7: Using DeFi Smart Contracts

---

#### 1) Create a Truffle Project and Configure it on Infura.

The only difference with the previous TD, is that instead of configuring our truffle with the mnemonic to our wallet, and the Infura API Key straight from truffle-config.js, we imported them from an environment file which is ignored by our git repo.

#### 2) Import Uniswap and Open Zeppelin libraries.

We had installed the Open Zeppelin library from the previous TD, so we simply installed the Uniswap Library, from which we imported *IUniswapV2Router02.sol* to use its function to add and remove liquidity to our pool.

#### 3) Claim Tokens from [0xc7fff638ea11817ca05533f4ec497632cfe07ec5](https://rinkeby.etherscan.io/token/0xc7fff638ea11817ca05533f4ec497632cfe07ec5).

Here it the transaction's hash from our claim: [0x1fc307d81f579bd6b31fff7ec17d466f712c647f71c1261df7cba3707325e43d](https://rinkeby.etherscan.io/tx/0x1fc307d81f579bd6b31fff7ec17d466f712c647f71c1261df7cba3707325e43d)

#### 4) Buy token [0xc7fff638ea11817ca05533f4ec497632cfe07ec5](https://rinkeby.etherscan.io/token/0xc7fff638ea11817ca05533f4ec497632cfe07ec5) on Uniswap.

Using the Uniswap UI we swapped 0.05 ETH for 0.24 TDE.

Transaction's hash: [0x52f043e8e5c6abf8202fb5034c74b04bd2e9028712990ae6fa315b0752481bcb](https://rinkeby.etherscan.io/tx/0x52f043e8e5c6abf8202fb5034c74b04bd2e9028712990ae6fa315b0752481bcb).

#### 5) Provide Liquidity to Token [0xc7fff638ea11817ca05533f4ec497632cfe07ec5](https://rinkeby.etherscan.io/token/0xc7fff638ea11817ca05533f4ec497632cfe07ec5).

In order to provide liquidity to the existing ETH/TDE pool, we first had to approve the Uniswap Router, and only then, we provided liquidity:

+ Approval: [0xfec3d7822747cbd4efafebeca90a5be41414ef1722b0e776df625c71d5ef034f](https://rinkeby.etherscan.io/tx/0xfec3d7822747cbd4efafebeca90a5be41414ef1722b0e776df625c71d5ef034f)
+ Liquidity: [0x7a4ab423eee82ccdacfbf30793920334ce1c364e3e51685cc225a7af9c9f3eda](https://rinkeby.etherscan.io/tx/0x7a4ab423eee82ccdacfbf30793920334ce1c364e3e51685cc225a7af9c9f3eda)

#### 6) Deploy an ERC20 Token.

The solidity code of said token can be found under the name of ERC20RMM.sol in this repo.  

+ Deployment Transaction: [0x41df2dc3d036f5e67b2c1368ab4ef1dd5d8ec2bdc39f5e94263f401ab1487ebd](https://rinkeby.etherscan.io/tx/0x41df2dc3d036f5e67b2c1368ab4ef1dd5d8ec2bdc39f5e94263f401ab1487ebd)

+ Contract Address: [0x637AD4164afAD756b0f968C14d48970D55F352fC](https://rinkeby.etherscan.io/address/0x637AD4164afAD756b0f968C14d48970D55F352fC)

We will now refer to our token with its ticker, RMM.

#### 7) Create a Liquidity Pool for your Token.

Using the Uniswap UI we created a new liquidity pool for our token by first approving the Uniswap Router, then providing the liquidity we wanted to set the price of our token.

+ Approval: [0xa2f3e2f7048d6d4aee57da4ddd911cae3615df74d2cf51385cc45dcf75945d72](https://rinkeby.etherscan.io/tx/0xa2f3e2f7048d6d4aee57da4ddd911cae3615df74d2cf51385cc45dcf75945d72)
+ Liquidity: [0x163c4488f231eace6f3f784e2571c0f8b29b0017b350a0e7478ced10fc604025](https://rinkeby.etherscan.io/tx/0x163c4488f231eace6f3f784e2571c0f8b29b0017b350a0e7478ced10fc604025)

#### 8) Create a Contract that can Hold your Token and Deposit it in the Uniswap Pool.

The solidity code of our contract can be found in UniswapLiquidity.sol.

The contract has two functions which allows the user to deposit both RMM and ETH into it, only after having approved the contract to transfer RMM tokens. Once the user have completed the deposits, by calling the functions addLiquidity of our contract, and providing the correct arguments to it, he will add liquidity to the ETH/RMM pool. 

Here the transactions involved:

+ UniswapLiquidity deployment: [0x76df382d72b21ae93c95ccd5c3b80b1dbf6448c09ed67f8d68c2e9e0da88991c](https://rinkeby.etherscan.io/tx/0x76df382d72b21ae93c95ccd5c3b80b1dbf6448c09ed67f8d68c2e9e0da88991c)
+ UniswapLiquidity contract address: [0xe78eE0Bae53a5582f9bc025F071ffA22ac44D7fb](https://rinkeby.etherscan.io/address/0xe78ee0bae53a5582f9bc025f071ffa22ac44d7fb)
+ ProvideLiquidity: [0x59c8880f3d3d6684c8be9a77d7e6fa96f3e0c76aacd4f6fc9adb3a9ac431698b](https://rinkeby.etherscan.io/tx/0x59c8880f3d3d6684c8be9a77d7e6fa96f3e0c76aacd4f6fc9adb3a9ac431698b)

#### 9) Enable your Contract to Withdraw Liquidity from Uniswap and Return RMMs to your Address.

We implemented the removeLiquidity function in our contract, but when called, it would fail with an underflow error from a subtraction.

+ Failed Transaction: [0xf808eb523e30837b86a3ba6b7978871fc56695a7bce35b18fec6bdfc23935cf5](https://rinkeby.etherscan.io/tx/0xf808eb523e30837b86a3ba6b7978871fc56695a7bce35b18fec6bdfc23935cf5)

Moreover, we implemented a function which would return both ETH and RMM to the user who deposited them into the contract.

#### 10) Keep Track of Balances.

By using different mappings we could keep track of balances both inside the contract, and in the liquidity pool, here's an overview:

+ liquidityBalances: Mapping that keeps track of how many LP tokens each user has.
+ tokenBalancesInContract: Mapping the keeps track of the RMM balances inside the contract, which gets updated each time the RMM balance varies.
+ etherBalancesInContract: same as the mapping above, except for ETH.
+ tokenBalancesLiquidity: Net amount of RMM tokens pooled by the user.
+ etherBalancesLiquidity: Net amount of ETH pooled by the user.