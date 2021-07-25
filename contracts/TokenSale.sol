pragma solidity ^0.6.0;

import "./Token.sol";

contract TokenSale{
	address payable admin;
	Token public tokenContract;
	uint256 public tokenPrice;
	uint256 public tokensSold;

	event Sell(address _buyer, uint256 _amount);

	constructor(Token _tokenContract, uint256 _tokenPrice) public{
		admin = msg.sender;
		tokenContract = _tokenContract;
		tokenPrice = _tokenPrice;
		//tokenContract.transfer(msg.sender, 75000000);
	}

	function multiply(uint256 a, uint256 b) internal pure returns (uint256 c) {
	    if (a == 0) {
	      return 0;
	    }
	    c = a * b;
	    assert(c / a == b);
	    return c;
    }

	function buyTokens(uint256 _numberOfTokens) public payable {

		require(msg.value == multiply(_numberOfTokens, tokenPrice));
		require(tokenContract.balanceOf(address(this)) >= _numberOfTokens * tokenPrice);
		// Buy functionality
		require(tokenContract.transfer(msg.sender, _numberOfTokens));
		tokensSold += _numberOfTokens;
		emit Sell(msg.sender, _numberOfTokens);
	}

	function endSale() public {
		require(msg.sender == admin);
		require(tokenContract.transfer(admin, tokenContract.balanceOf(address(this))));

    
        // Just transfer the balance to the admin
        admin.transfer(address(this).balance);
        //selfdestruct(admin);
      //  tokenContract.transfer(admin, address(this).balance);
	}
}      