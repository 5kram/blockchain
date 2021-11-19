/// Ethereum Game in Solidity
/// 2 players betting ETH's whether or not P2 can guess the choice of P1 
pragma solidity ^0.8.9;

contract CoinFlip {
	address payable public player1;
	/// Commitment is a keccak256 hash of a choice(bool) and a random nonce(uint256)
	bytes32 public player1Commitment;
	
	uint256 public betAmount;
	
	address payable public player2;
	bool public player2Choice;
	
	uint256 public expiration = 2**256-1;
	
	/// P1 creates the contract by betting ETHs
	/// and storing the hash on the blockchain
	constructor(bytes32 commitment) payable {
		player1 = payable(msg.sender);
		player1Commitment = commitment;
		betAmount = msg.value;
	}

	/// P1 can terminate the game, if P2 has not bet yet
	/// Bet amount is returned to P1
	function cancel() public {
		require(msg.sender == player1, "Cancel Error: Sender is not P1");
		require(player2 == address(0x0), "Cancel Error: P2 Exists");
		
		betAmount = 0;
		payable(msg.sender).transfer(address(this).balance);
	}

	/// P2 makes a predection (true or false)
	/// P2 bets the same amount as P1
	/// The game starts after betting and lasts 24 h
	function takeBet (bool choice) public payable {
		require(player2 == address(0x0), "takeBet Error: P2 already exists");
		require(msg.value == betAmount, "takeBet Error: Wrong Bet Ammount");
		
		player2 = payable(msg.sender);
		player2Choice = choice;
		
		expiration = block.timestamp + 24 hours;
	}

	/// P1 reveals the choice and the nonce he used for commitment
	/// P2 wins if the comparison of the hashes is true
	function reveal(bool choice, uint256 nonce) public {
		require(player2 != address(0x0), "reveal Error: P2 Address");
		require(block.timestamp < expiration, "reveal Error: Time Problem");
		
		require(keccak256(abi.encodePacked(choice, nonce)) == 	player1Commitment);
		
		if (player2Choice == choice) {
			payable(player2).transfer(address(this).balance);
		} 
		else {
			payable(player1).transfer(address(this).balance);
		}
	}

	/// If 24 h has passed without revealing P1 commitment
	/// P2 can claim both bets
	function claimTimeout() public {
		require(block.timestamp >= expiration);
		
		payable(player2).transfer(address(this).balance);
	}
}
	
