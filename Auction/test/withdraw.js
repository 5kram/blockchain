const Auction = artifacts.require("Auction");
const truffleAssert = require('truffle-assertions');


contract("Higher bidder withdraws", async accounts => {
	
	it("withdraw() should fail if highestBidder withdraws", async () => {
		const instance = await Auction.deployed();
    await instance.bid({from: accounts[1], value: 5})
    await instance.bid({from: accounts[2], value: 10})
	 	await truffleAssert.reverts(
   		instance.withdraw({ from: accounts[2] }),
    	"You can not withdraw!"
  	);
 	});

}); 