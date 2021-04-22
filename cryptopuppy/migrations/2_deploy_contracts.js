const Cryptopuppy = artifacts.require("Cryptopuppy");

module.exports = function (deployer) {
  deployer.deploy(Cryptopuppy, 10000);
};