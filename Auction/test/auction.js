const Auction = artifacts.require("Auction");
const truffleAssert = require('truffle-assertions');


contract("Auction test", async accounts => {

	it("should set highestBid correctly", async () => {
		const instance = await Auction.deployed();
		await instance.bid({from: accounts[1], value: 5})
		await instance.bid({from: accounts[2], value: 10})
		const highestBid= await instance.highestBid.call();
		assert.equal(highestBid, 10);
  	});

	it("should set contractBalance correctly", async () => {
		const instance = await Auction.deployed();
		const contractBalance = await instance.contractBalance.call();
		assert.equal(contractBalance, 15);
  	});
	
	it("withdraw() should fail if highestBidder withdraws", async () => {
		const instance = await Auction.deployed();
	  	await truffleAssert.reverts(
   			instance.withdraw({ from: accounts[2] }),
    			"You can not withdraw!"
    		);
 	});

 	it("should return bid value correctly after withdraw()", async () => {
		const instance = await Auction.deployed();
		const balanceBefore = await web3.eth.getBalance(accounts[1])
		instance.withdraw({ from: accounts[1] })
		const balanceAfter = await web3.eth.getBalance(accounts[1])
		// set gasPrice to 1 wei in truffle-config.js
		assert.equal(balanceBefore, balanceAfter - 1);
  	});

  	it("should set contractBalance correctly after withdraw()", async () => {
  		const instance = await Auction.deployed();
  		const contractBalance = await instance.contractBalance.call()
  		assert.equal(contractBalance, 10);
  	});

  	it("bid() should fail if bid is lower than highestBid", async () => {
		const instance = await Auction.deployed();
	  	await truffleAssert.reverts(
   			instance.bid({ from: accounts[1], value: 5 }),
    			"Not high enough bid!"
    		);
 	});

 	it("withdraw() should fail if user is not a bidder", async () => {
		const instance = await Auction.deployed();
	  	await truffleAssert.reverts(
   			instance.withdraw({ from: accounts[1] }),
    			"You are not a bidder!"
    		);
 	});

 	it("should set highestBid correctly when user bid() again", async () => {
		const instance = await Auction.deployed();
		await instance.bid({from: accounts[1], value: 15})
		await instance.bid({from: accounts[2], value: 10})
		const highestBid = await instance.highestBid.call();
		assert.equal(highestBid, 20);
  	});

}); 
