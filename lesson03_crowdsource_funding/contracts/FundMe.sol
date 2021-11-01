// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;


import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    mapping(address => uint256) public addressToAmountFunded;
    
    address public owner;
    address[] public funders;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function fund() public payable {
        // $50
        
        uint256 minimumUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more eth");
        
        addressToAmountFunded[msg.sender] += msg.value;
        // what the eth => usd conversion rate is
        funders.push(msg.sender);
    }
    
    
    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }
    
    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        // 430749000000
        return uint256(answer);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) /10000000;
        return ethAmountInUsd;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function withdraw () payable onlyOwner public
     {
         msg.sender.transfer(address(this).balance);
         for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
             address funder = funders[funderIndex];
             addressToAmountFunded[funder] = 0;
         }
         funders = new address[](0);
     }
}