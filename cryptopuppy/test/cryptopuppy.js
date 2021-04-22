const Cryptopuppy = artifacts.require("Cryptopuppy");
const truffleAssert = require('truffle-assertions');


contract("Cryptopuppy test", async accounts => {
	it("should set mintingCost correctly", async () => {
    	const instance = await Cryptopuppy.deployed();
    	const mintingCost = await instance.mintingCost.call();
    	assert.equal(mintingCost, 10000);
  	});

	it("mint() should fail if msg.value is not equal to mintingCost", async () => {
	    const instance = await Cryptopuppy.deployed();
	  	await truffleAssert.reverts(
   			instance.mint({ value: 1 }),
    		"You have not paid the minting cost!"
    	);
 	}); 

	it("buy() should fail if salePrice is not paid", async () => {
	    const instance = await Cryptopuppy.deployed();
	    await instance.mint("bob", {value: 10000})
	    await instance.sell(0, 20000)
	  	await truffleAssert.reverts(
   			instance.buy(0, { value: 1, from: accounts[1] }),
    		"You have not paid the sale price!"
    	);
 	});

	it("buy() should fail if puppy is not for sale", async () => {
	    const instance = await Cryptopuppy.deployed();
	    await instance.mint("george", {value: 10000})
	  	await truffleAssert.reverts(
   			instance.buy(1, { value: 20000, from: accounts[1] }),
    		"This puppy is not for sale!"
    	);
 	});
}); 