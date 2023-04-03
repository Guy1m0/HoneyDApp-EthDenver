// SPDX-License-Identifier: MIT
// 1. Pragma
pragma solidity ^0.8.7;
// 2. Imports
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

// 3. Interfaces, Libraries, Contracts
//error FundMe__NotOwner();

contract Checker {
    event Unstable(string token, uint256 old_price, uint256 new_price);
    // Type Declarations
    using PriceConverter for uint256;

    // State variables
    //uint256 public constant MINIMUM_USD = 10 * 10**18;
    address private immutable owner;
    //address[] private s_funders;
    //mapping(address => uint256) private s_addressToAmountFunded;
    AggregatorV3Interface private s_priceFeed;
    AggregatorV3Interface private USDC_priceFeed;
    AggregatorV3Interface private BTC_priceFeed;

    uint256 public percent = 100;
    uint256 private last_price;

    // Events (we have none!)

    constructor() {
        // chain link price feed address: 
        // https://docs.chain.link/data-feeds/price-feeds/addresses
        address ETH_USD_addr = 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e;
        address USDC_USD_addr = 0xAb5c49580294Aff77670F839ea425f5b78ab3Ae7;
        address BTC_USD_addr = 0xA39434A63A52E749F02807ae27335515BA4b07F7;
        s_priceFeed = AggregatorV3Interface(ETH_USD_addr);
        USDC_priceFeed = AggregatorV3Interface(USDC_USD_addr);
        BTC_priceFeed = AggregatorV3Interface(BTC_USD_addr);
        owner = msg.sender;
        //last_price = getETHPrice();
    }

    function abs(int x) private pure returns (int) {
        return x >= 0 ? x : -x;
    }

    function change_lot() public returns (bool){
        uint256 new_price = getETHPrice();
        if (new_price > last_price){
            if ((new_price - last_price) > last_price * 20 / 100){
                emit Unstable('ETH', last_price, new_price);
                last_price = new_price;
                return true;
            }
        }
        else{
            if ((last_price - new_price) > last_price * 20 / 100){
                last_price = new_price;
                return true;
            }
        }
        last_price = new_price;
        return false;
    }
    
    function setPrice(uint256 price) public {
        require(msg.sender == owner);
        last_price = price;
        //last_price = getETHPrice();
    }

    function setPercent(uint256 _p) public {
        percent = _p;
    }
        
    function getETHPrice() public view returns (uint256) {
        (, int256 answer, , , ) = s_priceFeed.latestRoundData();
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000) * percent / 100;
    }

    function getUSDCPrice() public view returns (uint256) {
        (, int256 answer, , , ) = USDC_priceFeed.latestRoundData();
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);
    }

    function getBTCPrice() public view returns (uint256) {
        (, int256 answer, , , ) = BTC_priceFeed.latestRoundData();
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}
