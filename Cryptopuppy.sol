// SPDX-License-Identifier: GLP-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Cryptopuppy {
    
    uint public mintingCost;
    
    constructor(uint _mintingCost) {
        mintingCost = _mintingCost;
    }
    
    struct Puppy {
        string name;
        address owner;
        bytes32 dna;
        uint salePrice;
    }
    
    Puppy[] public puppies;
    
    /* Mint a unique puppy.
     */
    function mint(string memory _name) public payable {
        require(msg.value == mintingCost, "You have not paid the minting cost!");
        
        Puppy memory p;
        p.name = _name;
        p.owner = msg.sender;
        p.dna = keccak256(abi.encodePacked(_name, block.timestamp, puppies.length));
        
        puppies.push(p);
    }
    
    function ownerOf(uint _puppyId) public view returns(address) {
        return puppies[_puppyId].owner;
    }
    /* Breed two puppies, to create a unique one.
     */
    function breed(string memory _name, uint _parentId1, uint _parentId2) public {
        require(msg.sender == ownerOf(_parentId1) && msg.sender == ownerOf(_parentId2), "You are not the owner of the puppies!");   
        Puppy memory p;
        p.name = _name;
        p.owner = msg.sender;
        p.dna = keccak256(abi.encodePacked(puppies[_parentId1].dna, block.timestamp, puppies[_parentId2].dna, puppies.length));
        
        puppies.push(p);
    }
    /* Sell a puppy.
     */
    function sell(uint _puppyId, uint _salePrice) public {
        require(msg.sender == ownerOf(_puppyId),"You do not own the puppy!");
        puppies[_puppyId].salePrice = _salePrice;
    }
    /* Buy a puppy.
     */
    function buy(uint _puppyId) public payable {
        uint salePrice = puppies[_puppyId].salePrice;
        require(salePrice > 0, "This puppy is not for sale!");
        require(msg.value == salePrice, "You have not paid the sale price!");
        
        payable(puppies[_puppyId].owner).transfer(salePrice);
        puppies[_puppyId].owner = msg.sender;
    }
    
    receive() external payable { }
}

