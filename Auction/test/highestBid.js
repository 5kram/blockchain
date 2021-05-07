const Auction = artifacts.require("Auction");
const truffleAssert = require('truffle-assertions');


contract("highestBid", async accounts => {
	
	it("should set highestBid correctly", async () => {
    	const instance = await Auction.deployed();
        await instance.bid({from: accounts[1], value: 5})
        await instance.bid({from: accounts[2], value: 10})
    	const highestBid= await instance.highestBid.call();
    	assert.equal(highestBid, 10);
  	});

}); 