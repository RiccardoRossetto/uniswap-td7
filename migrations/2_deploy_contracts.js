var ERC20RMM = artifacts.require("./ERC20RMM");

module.exports = function (deployer) {
	deployer.deploy(ERC20RMM, "10000000000000000000000");
}
