pragma solidity ^0.6.0;

import "./ERC20RMM.sol";
import "/home/joukowski/node_modules/@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract UniswapLiquidity {
	
	address internal constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
	IUniswapV2Router02 public uniswapRouter = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);

	address internal constant TOKEN_ADDRESS = 0x637AD4164afAD756b0f968C14d48970D55F352fC;
        ERC20RMM tokenRMM = ERC20RMM(TOKEN_ADDRESS);
	
	uint[] public balances;
	
	mapping(address => uint) public tokenBalances;
	mapping(address => uint) public etherBalances;
	mapping(address => bool) public addressExists;
	
	function depositTokens(uint _amount) public {
		
		tokenRMM.transferFrom(msg.sender, address(this), _amount);
		tokenBalances[msg.sender] += _amount;		

	}

	function depositEther() payable public {

		etherBalances[msg.sender] += msg.value;
	}



	function addLiquidity(
		uint _amountETHDesired,
		uint _amountTokenDesired,
		uint _amountTokenMin,
		uint _amountETHMin,
		address _to,
		uint _deadline
		) public {
		(uint _tokens, uint _ether, uint _liquidity) = uniswapRouter.addLiquidityETH{value: _amountETHDesired}(
					TOKEN_ADDRESS, 
					_amountTokenDesired, 
					_amountTokenMin, 
					_amountETHMin, 
					_to,
					_deadline
					);

		tokenBalances[msg.sender] -= _tokens;
		etherBalances[msg.sender] -= _ether;
	}

	function removeLiquidity(
		uint _liquidity,
		uint _amountTokenMin,
		uint _amountETHMin,
		uint _deadline
		) public {
		uniswapRouter.removeLiquidityETH(
			TOKEN_ADDRESS,
			_liquidity,
			_amountTokenMin,	
			_amountETHMin,
			msg.sender,
			_deadline);
	} 

}
