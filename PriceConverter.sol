// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/**
* @title PriceConverter 
* @author ArefXV
* @dev This library provides utility functions to fetch the latest ETH price in USD 
*      and calculate ETH to USD conversion rates using Chainlink price feeds.
*      It also includes a function to get the version of the price feed contract.
*/
library PriceConverter {

    /**
    * @notice Fetches the latest ETH price in USD from the Chainlink price feed.
    * @return The latest ETH price in USD, scaled to 18 decimals.
    */
    function getPrice() internal view returns (uint256) {
        // Initialize the price feed contract at the specified address.
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        
        // Retrieve the latest round data, including the price (answer).
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        
        // Convert the answer to a 18-decimal format by multiplying with 1e10.
        return uint256(answer * 1e10);
    }

    /**
    * @notice Converts a given ETH amount to its equivalent USD value.
    * @param ethAmount The amount of ETH to be converted (scaled to 18 decimals).
    * @return The equivalent USD value for the provided ETH amount, scaled to 18 decimals.
    */
    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        // Fetch the latest ETH price in USD.
        uint256 ethPrice = getPrice();
        
        // Calculate and return the ETH amount in USD.
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    
}
