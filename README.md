**SimpleFundRaising Contract**


Welcome to the **SimpleFundRaising** contract! This project provides a straightforward and simple way to manage decentralized fundraising in Ethereum or its USD equivalent. Designed for simplicity, this contract is ideal for learning and basic use cases, not professional-grade implementations.

___


**Overview**


__Key Features:__


-Simple and Efficient Fundraising: Accepts contributions in ETH or equivalent USD.


-Funding Limits: Implements a maximum number of funders and a total fundraising goal.


-Error Handling: Provides custom errors for clear and efficient issue resolution.


-Owner-Controlled Withdrawals: Ensures only the contract owner can withdraw funds.


-Real-Time Tracking: Tracks total funds raised and contributors.


-Security Features: Utilizes `revert` statements to enforce rules and prevent misuse.

___


**Table of Contents**


1.Getting Started


2.Contract Details


3.Functions


4.Usage


5.Security Considerations


6.Deployment


7.Contributing


8.License

___


**Getting Started**


__Prerequisites:__


-Solidity Compiler: Version 0.8.26 or higher.


-Chainlink Aggregator: For fetching the latest ETH/USD conversion rate.


**Installation:**


__Clone the repository:__

```bash
git clone https://github.com/yourusername/SimpleFundRaising.git
```


__Install dependencies:__

```bash
npm install
```

__Compile the contract:__

```bash
npx hardhat compile
```


___


**Contract Details**


__Global Constants:__


-MINIMUM_USD (1e18): Minimum amount in USD (scaled to 18 decimals).


-MINIMUM_ETH (4e14): Minimum ETH contribution.


-GOAL (5e18): Fundraising goal in wei (5 ETH).


-MAX_FUNDERS (3): Maximum number of funders allowed.


__State Variables:__


`i_owner`: Immutable address of the contract owner.


`totalFunds`: Tracks the total amount of funds raised.


`listOfFunders`: Stores the addresses of contributors.


`addressToAmountFunded`: Maps contributor addresses to the amount funded.


___


**Functions**


1. `fundWithUsd()`



Description: Accepts contributions in USD (via ETH) based on the latest price feed.


__Validation:__


Reverts if the contribution is below `MINIMUM_USD`.


Reverts if the total number of funders exceeds `MAX_FUNDERS`.


**Usage:**


```solidity
simpleFundRaising.fundWithUsd{value: msg.value}();
```



2. `fundWithEth()`



Description: Accepts contributions directly in ETH.


__Validation:__


Reverts if the contribution is below `MINIMUM_ETH`
.

Reverts if funders exceed the `MAX_FUNDERS` limit.


**Usage:**


```solidity
simpleFundRaising.fundWithEth{value: msg.value}();
```



3. `withdraw()`



Description: Allows the owner to withdraw all funds.


Modifiers: `onlyOwner`


**Usage:**


```solidity
simpleFundRaising.withdraw();
```



4. `getBalance()`



Description: Returns the current balance of the contract.



**Usage:**



```solidity
uint balance = simpleFundRaising.getBalance();
```


5. `getVersion()`



Description: Returns the version of the Chainlink price feed.


**Usage:**



```solidity
uint version = simpleFundRaising.getVersion();
```


6. `getTotalFunders()`



Description: Returns the total number of funders.



**Usage:**



```solidity
uint totalFunders = simpleFundRaising.getTotalFunders();
```

___



__Usage__


**Example Workflow:**


1. Deploy the contract.



2. Fund the contract:



Users can call `fundWithUsd` or `fundWithEth` to contribute.



3. Monitor total funds:



Use `getBalance` to check the raised amount.



4. Withdraw funds:



The contract owner can call `withdraw` to access the funds once the goal is met.


___



**Security Considerations**


1. Owner Privileges:



Only the owner can withdraw funds to prevent unauthorized access.



2. Custom Errors:



Efficient gas usage through custom `revert` messages.



3. Goal and Limit Enforcement:



Contributions halt once the fundraising goal is met.



4. Safe Fund Withdrawal:



Uses low-level `call` to transfer funds securely.


___



**Deployment**



1. Deploy the contract on your desired network:



```bash
npx hardhat run scripts/deploy.js --network rinkeby
```



2. Verify the deployment:



```bash
npx hardhat verify --network rinkeby DEPLOYED_CONTRACT_ADDRESS
```

___


**Contributing**



We welcome contributions! Please follow these steps:



1. Fork the repository.



2. Create a new branch:



```bash
git checkout -b feature/your-feature-name
```



3. Make your changes and commit them.



4. Push your changes:



```bash
git push origin feature/your-feature-name
```



5. Submit a pull request.


___


**License**

__No license selected yet.__

This project currently does not specify a license. Contributors and users are advised to check the repository for updates.


---

**Author**

__ArefXV__

[https://linktr.ee/arefxv]


Simple solutions for complex problems.


---

Feel free to customize it further!
