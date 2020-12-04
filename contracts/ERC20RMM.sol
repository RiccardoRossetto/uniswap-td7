pragma solidity ^0.6.0;
import "/usr/local/lib/node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol"

contract ERC20RMM is ERC20 {

	constructor(uint256 initialSupply) public ERC20("RMM-ERC20", "RMM") {
		_mint(msg.sender, initialSupply)
	}

	function claimTokens() {
		_mint(msg.sender, 1000000000000000000000)
	}
}
