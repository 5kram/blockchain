// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;

contract Auction {
    address private highestBidder; // The highest bidder's address
    address owner;
    uint bidderCounter = 0;
    uint private highestBid; // The amount of the highest bid
    uint contractBalance = 0;
    mapping(address => uint) private userBalances; // mapping for the amount to return
    
    constructor() {
        // contractor
        // 1. Initialize highest bid and the bidder's address
        owner = msg.sender;
        highestBid = 0;
        highestBidder = owner;
        userBalances[owner] = 0;
    }
    
    modifier onlyBidder() {
        require(isBidder(msg.sender), "You are not a bidder!");
        _;
    }
    
       
    function bid(address _addr) public payable {
        uint _bid = msg.value;
        // Function to process bid
        // 1. Check if the bid is greater than the current highest bid
        if (_bid > highestBid) {
            // 2. Update status variable and the amount to return
            userBalances[highestBidder] = highestBid;
            highestBid = _bid;
            highestBidder = _addr;
            }
        userBalances[_addr] = _bid;
        contractBalance += _bid;
    }
    
    function isBidder(address _addr) private view returns(bool) {
            return (userBalances[_addr] != 0);              
    }
    
    function withdraw() public onlyBidder {
        // Function to withdraw the amount of bid to return
        // 1. Check if the amount to return is greater than zero
        if (userBalances[msg.sender] > 0 && msg.sender != highestBidder && isBidder(msg.sender)) {
            // 2. Update status variable and return bid
            uint _bid = userBalances[msg.sender];
            userBalances[msg.sender] = 0;
            msg.sender.transfer(_bid);
            contractBalance -= _bid;
        }
    }
    
    function getBidderBalance(address _addr) public view returns(uint) {
        require(isBidder(_addr), "Is not bidder address.");
        return address(_addr).balance;
    }
    
    function getContractBalance() public view returns(uint) {
            return contractBalance;
    }
    
    function getHighestBidder() public view returns(address) {
        require(isBidder(highestBidder), "No highest bidder.");
        return address(highestBidder);
    }
    
    function getHighestBid() public view returns(uint) {
        require(isBidder(highestBidder), "No highest bidder.");
        return highestBid;    
    }
    
    receive() external payable { }
}
