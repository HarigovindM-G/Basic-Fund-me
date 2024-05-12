// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{


    function getPrice() public view returns(uint256) {
            AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
            (,int256 price,,,)=priceFeed.latestRoundData();
            return uint(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 eth_price = getPrice();
        uint256 ethAmountInUsd = (ethAmount * eth_price)/ 1e18;
        return ethAmountInUsd;
    }

}