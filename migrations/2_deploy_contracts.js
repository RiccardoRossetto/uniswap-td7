//var ERC20RMM = artifacts.require("./ERC20RMM");
var UniswapLiquidity = artifacts.require("./UniswapLiquidity");

module.exports = function (deployer) {
//	deployer.deploy(ERC20RMM, "10000000000000000000000");
	deployer.deploy(UniswapLiquidity);
}
