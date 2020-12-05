pragma solidity ^0.6.0;

import "./ERC20RMM.sol";
import "/home/joukowski/node_modules/@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract UniswapLiquidity {
	
	address internal constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
	IUniswapV2Router02 public uniswapRouter = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);

	address internal constant TOKEN_ADDRESS = 0xE96888C5EeD88ff5f2a1e4a167cA8A3D35DD382f;
        ERC20RMM tokenRMM = ERC20RMM(TOKEN_ADDRESS);	
	
	mapping(address => uint) public tokenBalances;
	mapping(address => bool) public addressExists;

	function depositToken(uint _amount) public {
		
		tokenRMM.transferFrom(msg.sender, address(this), _amount);
		
		if (!addressExists[msg.sender]){
			
 			tokenBalances[msg.sender] = _amount;
			addressExists[msg.sender] = true;

		} else if (addressExists[msg.sender]) {tokenBalances[msg.sender] += _amount;}

	}

	function addLiquidity(
		uint _amountTokenDesired, 
		uint _amountTokenMin, 
		uint _amountETHMini, 
		uint _deadline
		) public {
		uniswapRouter.addLiquidityETH(TOKEN_ADDRESS, 
			_amountTokenDesired, 
			_amountTokenMin, 
			_amountETHMin, 
			msg.sender, 
			_deadline);
	}
}
