//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

// Import the AggregatorV3Interface from Chainlink to use price feeds in the contract
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// Import the PriceConverter library for converting between ETH and USD values
import {PriceConverter} from "./PriceConverter.sol";

/**
* @title SimpleFundRaising
* @author ArefXV
* @notice This contract enables fundraising in either USD or ETH with certain conditions.
*         The contract allows a maximum of 3 funders and has a goal of 5 ETH.
*         Once the goal is reached or the maximum number of funders is hit, no further funding is allowed.
*/

contract SimpleFundRaising {
    // Using the PriceConverter library to convert ETH to USD based on the conversion rate.
    using PriceConverter for uint256;

    // Custom errors for better gas efficiency and error handling
    error fundWithUsd__shouldSendMoreAmount(); // Error if the USD fund sent is less than the minimum required
    error onlyOwner__mustBeOwner(); // Error if the sender is not the owner of the contract
    error fundWithUsd__maximumNumberOfFundersReached(); // Error if the max number of funders is reached for USD
    error fundWithUsd__maximumFundersReached(); // Error if the max number of funders is reached for USD
    error fundWithEth__maximumNumberOfFundersReached(); // Error if the max number of funders is reached for ETH
    error fundWithEth__maximumFundersReached(); // Error if the max number of funders is reached for ETH
    error goalReached__fundingIsClosed(); // Error if the funding goal has been reached and no more funds are accepted

    // Constants defining the contract behavior:
    uint256 public constant MINIMUM_USD = 1e18; // Minimum amount of USD (in wei) required for each funder
    uint256 public constant MINIMUM_ETH = 4e14; // Minimum amount of ETH (in wei) required for each funder
    uint256 public constant GOAL = 5e18; // The goal of the fundraising (5 ETH in wei)
    uint256 public constant MAX_FUNDERS = 3; // Maximum number of funders allowed (3 funders)

    // Variable to track the total amount of funds raised
    uint256 public totalFunds;

    // Immutable variable for the owner's address; set during contract deployment
    address public immutable i_owner;

    // Array to store the list of funders
    address[] public listOfFunders;

    // Mapping to store the amount funded by each address
    mapping(address => uint256 amountFunded) public addressToAmountFunded;

    // Constructor to initialize the owner of the contract as the deployer
    constructor() {
        i_owner = msg.sender; // Set the contract deployer as the owner
    }

    // Modifier to ensure that only the contract owner can call certain functions
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert onlyOwner__mustBeOwner(); // Revert if the sender is not the owner
        }
        _;
    }

    // Modifier to ensure that the funding goal has not yet been reached
    modifier goalReached() {
        if (totalFunds >= GOAL) {
            revert goalReached__fundingIsClosed(); // Revert if the goal is reached
        }
        _;
    }

    /**
    * @dev Function to allow users to fund the contract in USD (through conversion from ETH).
    *      Reverts if the funding goal has been reached or if the user hasn't sent enough ETH.
    */
    function fundWithUsd() public payable goalReached {
        // Ensure the number of funders does not exceed the maximum allowed
        if (listOfFunders.length >= MAX_FUNDERS) {
            revert fundWithUsd__maximumFundersReached(); // Revert if the maximum number of funders is reached
        }

        // Ensure the sent value is above the minimum USD value threshold
        if (msg.value.getConversionRate() < MINIMUM_USD) {
            revert fundWithUsd__shouldSendMoreAmount(); // Revert if not enough USD equivalent ETH was sent
        }

        // Add the funder's address to the list of funders
        listOfFunders.push(msg.sender);
        // Update the amount funded by the current address
        addressToAmountFunded[msg.sender] += msg.value;
        // Update the total funds raised
        totalFunds += msg.value;
    }

    /**
    * @dev Function to allow users to fund the contract directly in ETH.
    *      Reverts if the funding goal has been reached or if the user hasn't sent enough ETH.
    */
    function fundWithEth() public payable goalReached {
        // Ensure the number of funders does not exceed the maximum allowed
        if (listOfFunders.length >= MAX_FUNDERS) {
            revert fundWithEth__maximumFundersReached(); // Revert if the maximum number of funders is reached
        }
        
        // Ensure the sent ETH is above the minimum threshold
        if (msg.value < MINIMUM_ETH) {
            revert fundWithUsd__shouldSendMoreAmount(); // Revert if not enough ETH was sent
        }

        // Add the funder's address to the list of funders
        listOfFunders.push(msg.sender);
        // Update the amount funded by the current address
        addressToAmountFunded[msg.sender] += msg.value;
        // Update the total funds raised
        totalFunds += msg.value;
    }

    /**
    * @dev Function to allow the owner to withdraw the total funds raised.
    *      Clears the list of funders and resets the mapping of funds for each funder.
    */
    function withdraw() public onlyOwner {
        // Loop through the funders and reset their amounts funded to 0
        for (uint256 i = 0; i < listOfFunders.length; i++) {
            address funders = listOfFunders[i];
            addressToAmountFunded[funders] = 0; // Reset each funder's contribution
        }

        // Clear the list of funders
        listOfFunders = new address[](0);       // Transfer the balance to the owner (contract deployer)
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed!"); // Ensure the transfer is successful
    }

    /**
    * @dev Function to get the current balance of the contract (total ETH in the contract).
    * @return The balance of the contract in wei.
    */
    function getBalance() public view returns(uint256) {
        return address(this).balance; // Return the contract's current balance
    }

    /**
    * @dev Function to get the version of the Chainlink price feed being used.
    * @return The current version of the Chainlink price feed.
    */
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version(); // Return the version of the Chainlink price feed
    }

    /**
    * @dev Function to get the total number of funders who have contributed to the contract.
    * @return The number of funders.
    */
    function getTotalFunders() public view returns(uint256) {
        return listOfFunders.length; // Return the current number of funders
    }
}
