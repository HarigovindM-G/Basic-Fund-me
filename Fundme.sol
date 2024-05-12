// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe{

    using PriceConverter for uint256;

    address public immutable i_owner;

    constructor(){
        i_owner=msg.sender;
    }
    
    //562,618 - not using constant keyword 
    //543,319 - using constant keyword
    //520,616 - also using immutable keyword
    //497,990 - using custom errors

    uint256 public constant MINIMUM_USD= 50 * 1e18;
    
    address[] public funders;
    // Dictionary to store the address and amount 
    mapping(address=>uint256) public addressToAmount;


    function fund() public payable{

        require(msg.value.getConversionRate() >= MINIMUM_USD ,"Dint send enough Ether");
        funders.push(msg.sender);
        addressToAmount[msg.sender] += msg.value ;
        // we give *1e18 because , msg.value is in wei, 1 eth = 1e18
        // ETH-USD contract address 0x694AA1769357215DE4FAC081bf1f309aDC325306 , fetched from the price feed address in chain link docs
    }
    


    function withdraw() public onlyOwner {
        
        //setting the mapping to zero
        for (uint256 i=0; i<funders.length; i++) 
        {
          address funder = funders[i];
          addressToAmount[funder]= 0;
        }
        //resetting the funder array 
        funders = new address[](0);

        //withdrawing the fund from the contract
        // We are using call function here , send and tranfer can also be used 
        (bool callSuc,)=payable(msg.sender).call{value: address(this).balance}("");
        require(callSuc,"Call failed");

    }
    
    modifier onlyOwner{
        // require(msg.sender==i_owner ,"Only Owner can withdraw funds");
        if(msg.sender!=i_owner){revert NotOwner();}
        _;
        // _ represents the rest of the code 
    }

    // to handle payment directly to the contract without call data 
    receive() external payable {
        fund();
     }

    // to handle payment directly to the contract with call data 
     fallback() external payable {
        fund();
     }

}