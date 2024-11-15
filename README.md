**SimpleFundRaising Contract**
Welcome to the **SimpleFundRaising** contract! This project provides a straightforward and simple way to manage decentralized fundraising in Ethereum or its USD equivalent. Designed for simplicity, this contract is ideal for learning and basic use cases, not professional-grade implementations.



**Overview**


__Key Features:__


-Simple and Efficient Fundraising: Accepts contributions in ETH or equivalent USD.


-Funding Limits: Implements a maximum number of funders and a total fundraising goal.


-Error Handling: Provides custom errors for clear and efficient issue resolution.


-Owner-Controlled Withdrawals: Ensures only the contract owner can withdraw funds.


-Real-Time Tracking: Tracks total funds raised and contributors.


-Security Features: Utilizes `revert` statements to enforce rules and prevent misuse.


**Table of Contents**


1.Getting Started


2.Contract Details


3.Functions


4.Usage


5.Security Considerations


6.Deployment


7.Contributing


8.License


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


