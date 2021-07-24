const Token = artifacts.require("Token");
const TokenSale = artifacts.require("TokenSale");


module.exports = function (deployer) {
  deployer.deploy(Token, 100000000).then(function() {
    var tokenPrice = BigInt(1000000000000000000);
    return deployer.deploy(TokenSale, Token.address, tokenPrice);
  });
};
