const CoinFlip = artifacts.require("CoinFlip");

module.exports = function (deployer) {
  deployer.deploy(CoinFlip, "0x8a2fdc76316025471d7987c83d06026739af92a97cdab6903f02a3bc8b12b2a3", {from: "0x8DDE3A3a445534cA79DD88f3242CcBFAe36Ec3BA", value: 1000000000000000000});
};
