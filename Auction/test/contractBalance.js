const Auction = artifacts.require("Auction");
const truffleAssert = require('truffle-assertions');


contract("contractBalance", async accounts => {

	it("should set contractBalance correctly", async () => {
		const instance = await Auction.deployed();
    await instance.bid({from: accounts[1], value: 5})
    await instance.bid({from: accounts[2], value: 10})
    const contractBalance = await instance.contractBalance.call();
  	assert.equal(contractBalance, 15);
  	});

  it("should set contractBalance correctly after withdraw()", async () => {
		const instance = await Auction.deployed();
    instance.withdraw({ from: accounts[1] })
  	const contractBalance = await instance.contractBalance.call()
		assert.equal(contractBalance, 10);
  });

}); 