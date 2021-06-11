import React, { Component } from "react";
import CryptopuppyContract from "./contracts/Cryptopuppy.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { mintingCost: 0, web3: null, accounts: null, contract: null, input: "", inputPuppyId: null, puppy: null };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = CryptopuppyContract.networks[networkId];
      const instance = new web3.eth.Contract(
        CryptopuppyContract.abi,
        deployedNetwork && deployedNetwork.address,
      );
      
      const response = await instance.methods.mintingCost().call();
      
      instance.getPastEvents('NewPuppy', {
    	  fromBlock: 0,
    	  toBlock: 'latest'
      }, function(error, events){ console.log(events); })
        .then(function(events){
    	 console.log(events) // same results as the optional callback above
      });


      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance, mintingCost: response });
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  mint = async () => {
    const { accounts, contract } = this.state;

    // Stores a given value, this.state.input by default.
    await contract.methods.mint(this.state.input).send({ from: accounts[0], value: this.state.mintingCost });

    // Get the value from the contract to prove it worked.
    // const response = await contract.methods.get().call();

    // Update state with the result.
    // this.setState({ mintingCost: response });
  };

 getPuppy = async () => {
    const contract = this.state.contract;


    // Get the value from the contract to prove it worked.
     const response = await contract.methods.puppies(this.state.inputPuppyId).call();

    // Update state with the result.
     this.setState({ puppy: response }, () => {
     	console.log(this.state.puppy)
     	});
  };

  myChangeHandler = (event) => {
  	this.setState({input: event.target.value}, () => {
  		console.log(this.state.input) 
  	});
  }

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    
    let puppyInfo
    if (this.state.puppy == null) {
    	puppyInfo = ""
    }
    else {
    	puppyInfo = <div>
    	<div>name: {this.state.puppy.name}</div>
        <div style={{backgroundColor: "#"+this.state.puppy.dna.slice(-6)}}>dna: {this.state.puppy.dna}</div>
        <div>owner: {(this.state.puppy.owner === this.state.accounts[0]) ? "YOU" : this.state.puppy.owner}</div>
    	</div>
    }
    
    return (
      <div className="App">
        <h1>Cryptopuppy</h1>
        <div>The minting cost is: {this.state.mintingCost}</div>
        <input type="text" onChange={this.myChangeHandler} />
        <button onClick={this.mint}>Mint</button>
        <h2>Get puppy info</h2>
        <input type="text" onChange={(event) => {this.setState({inputPuppyId: event.target.value})}} />
        <button onClick={this.getPuppy}>Go</button>
        {puppyInfo}
      </div>
    );
  }
}

export default App;
