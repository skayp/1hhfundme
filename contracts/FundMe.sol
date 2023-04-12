// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "./PriceConverter.sol";

error FundMe_NotOwner();

/**@title A contract for crowd funding
 * @author Shashi Kant Pandey
 * @notice
 * @dev This is a note to developers
 */

//transaction cost 838233 > 817179
contract FundMe {
    using PriceConverter for uint256;
    //uint256 public minUsd=50*1e18;
    uint256 public constant MIN_USD = 50 * 1e18; //on using constant this variable doesnt take memory
    //2407 >307 gas
    address[] public funders;
    mapping(address => uint256) public addresstoAmountFunded;
    //address public owner;
    address public immutable i_owner;

    //2580 > 444 gas
    AggregatorV3Interface public priceFeed;

    //constructor is called first upon program execution
    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        //how to bring external data? use chain link coz its decentralised
        //set min fund amt
        // payable
        //wallet and contract can hold funds
        require(
            msg.value.getConversionRate(priceFeed) >= MIN_USD,
            "Sent less than 1"
        ); //1e18==1*10^18 =1ETH
        //we used library for getCOnversionRate otherwise getConversionRate(msg.value) would be used
        //msg.value and msg.sender is available globally
        //revert:if require fails then gas of all the work:s  done after it gets returned and all the work done before or after is undone
        //18 decimal places
        //Error string is stored as string array and takes p alots of space
        funders.push(msg.sender);
        addresstoAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        //require(msg.sender==owner,"Withdrawer is not owner"); //makes sure only owner can withdraw fund

        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addresstoAmountFunded[funder] = 0;
        }
        //Resetting the array means deleting
        funders = new address[](0);

        //actually send eth from contract
        //1st way transfer
        // payable(msg.sender).transfer(address(this).balance);
        //2nd way to transfer
        // bool sendSuccess= payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"Failed");
        //3rd way to transfer
        (bool callSuccess /*bytes memory dataReturned*/, ) = payable(msg.sender)
            .call{value: address(this).balance}("");
        require(callSuccess, "Failed");
    }

    modifier onlyOwner() {
        // require(msg.sender==i_owner,"Sender is not owner");
        if (msg.sender != i_owner) {
            revert FundMe_NotOwner();
        }
        _;
    }
}
