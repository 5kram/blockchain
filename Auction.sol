/* SPDX-License-Identifier: GPL-3.0
 */
pragma solidity >=0.7.0;

contract Auction {
    address public highestBidder;
    uint public highestBid;
    uint public contractBalance = 0;
    /* Mapping for the amount to return.
     */
    mapping(address => uint) private userBalances;
    
    /* Initialize highest bid, bidder's address.
     */
    constructor() {
        highestBid = 0;
        highestBidder = address(0);
    }
    
    modifier onlyBidder() {
        require(isBidder(msg.sender), "You are not a bidder!");
        _;
    }
    
    function isBidder(address _addr) private view returns(bool) {
        return (userBalances[_addr] != 0);              
    }
    
    /* Function to process bid.
     */
    function bid(address _bidder, uint _bid) public payable {
        /* Check if the bid is greater than the current highest bid
         */
        require(_bid > highestBid, "Not high enough bid!");
        /* Update status variable and the amount to return,
         */
        highestBid = _bid;
        highestBidder = _bidder;
        userBalances[_bidder] = _bid;
        contractBalance += _bid;
    }
    
    /* Function to withdraw the amount of bid to return.
     */
    function withdraw() public onlyBidder payable {
        /* Check if the amount to return is greater than zero
         * and if the sender isn't the highest bidder.
         */
        require(userBalances[msg.sender] > 0 && msg.sender != highestBidder, "You can not withdraw!");
        /* Update status variable and return bid.
         */
        uint _bid = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(payable(msg.sender).send(_bid),"Could not send bid.");
        contractBalance -= _bid;
    }
    
    receive() external payable {
    	bid(msg.sender, msg.value);
    }
}
