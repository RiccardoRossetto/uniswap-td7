pragma solidity ^0.6.0;

import "./ERC20RMM.sol";
import "/home/joukowski/node_modules/@uniswap/v2-periphery/contracts/UniswapV2Router02.sol";


contract UniswapLiquidity {
	
	UniswapV2Router02 routerUni = UniswapV2Router02("0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D");
        ERC20RMM tokenRMM = ERC20RMM("0xE96888C5EeD88ff5f2a1e4a167cA8A3D35DD382f");	
	
	mapping(address => uint) public tokenBalances;
	mapping(address => bool) public addressExists;

	function depositToken(uint _amount) public {
		
		tokenRMM.transferFrom(msg.sender, address(this), _amount);
		
		if (!addressExists[msg.sender]){
			
 			tokenBalances[msg.sender] = _amount;
			addressExists[msg.sender] = true;

		} else if (addressExists[msg.sender]) {tokenBalances[msg.sender] += _amount;}

	}

}
