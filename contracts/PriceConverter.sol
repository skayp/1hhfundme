// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; //impports this smc from github

library PriceConverter {
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        //This contracts inteeracts with contract outside of project
        //Address of outside contract by data feeds 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // AggregatorV3Interface priceFeed = AggregatorV3Interface(
        //     0x694AA1769357215DE4FAC081bf1f309aDC325306
        // );
        (, int256 price, , , ) = priceFeed.latestRoundData(); //priceof eth in USD
        //GIves price in 8 decimal place
        return uint256(price * 1e10);
    }

    //converts passed amount to dollars ignore name of function
    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountinUsd = (ethAmount * ethPrice) / 1e18; //calculator rounds it up
        return ethAmountinUsd;
    }
}
