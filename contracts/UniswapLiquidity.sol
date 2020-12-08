pragma solidity ^0.6.0;

import "./ERC20RMM.sol";
import "/usr/local/lib/node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "/home/joukowski/node_modules/@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract UniswapLiquidity {
	
	address internal constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
	IUniswapV2Router02 public uniswapRouter = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);

	address internal constant TOKEN_ADDRESS = 0x637AD4164afAD756b0f968C14d48970D55F352fC;
        ERC20RMM tokenRMM = ERC20RMM(TOKEN_ADDRESS);

	address internal constant TOKEN_ADDRESS_LP = 0x12d6e09766221048e27495EB04134B7c952FD016;
	IERC20 tokenLP = IERC20(TOKEN_ADDRESS_LP);	
	
	mapping(address => uint) public liquidityBalances;
	mapping(address => uint) public tokenBalancesInContract;
	mapping(address => uint) public etherBalancesInContract;
	mapping(address => uint) public tokenBalancesLiquidity;
	mapping(address => uint) public etherBalancesLiquidity;
	mapping(address => bool) public addressExists;
	
	function depositTokens(uint _amount) public {
		
		tokenRMM.transferFrom(msg.sender, address(this), _amount);
		tokenBalancesInContract[msg.sender] += _amount;		

	}

	function depositEther() payable public {

		etherBalancesInContract[msg.sender] += msg.value;
	}



	function addLiquidity(
		uint _amountETHDesired,
		uint _amountTokenDesired,
		uint _amountTokenMin,
		uint _amountETHMin
		) public {
		
		address _to = msg.sender;
		uint _deadline = now + 300;		
	
		tokenRMM.approve(UNISWAP_ROUTER_ADDRESS, _amountTokenDesired);
		
		(uint _tokens, uint _ether, uint _liquidity) = uniswapRouter.addLiquidityETH{value: _amountETHDesired}(
					TOKEN_ADDRESS, 
					_amountTokenDesired, 
					_amountTokenMin, 
					_amountETHMin, 
					_to,
					_deadline);
		
		liquidityBalances[msg.sender] += _liquidity;
		tokenBalancesInContract[msg.sender] -= _tokens;
		etherBalancesInContract[msg.sender] -= _ether;
		tokenBalancesLiquidity[msg.sender] += _tokens;
		etherBalancesLiquidity[msg.sender] += _ether;
	}


	function removeLiquidity(
		) public {

		address _to = msg.sender;
		uint _liquidity = liquidityBalances[msg.sender];
		uint _amountTokenMin = tokenBalancesLiquidity[msg.sender];
		uint _amountETHMin = etherBalancesLiquidity[msg.sender];
		uint _deadline = now + 300;		

		tokenLP.approve(UNISWAP_ROUTER_ADDRESS, tokenLP.balanceOf(msg.sender));

		(uint _tokens, uint _ether) = uniswapRouter.removeLiquidityETH(
			TOKEN_ADDRESS,
			_liquidity,
			_amountTokenMin - 100,	
			_amountETHMin - 100,
			_to,
			_deadline);

		liquidityBalances[msg.sender] = 0;
		tokenBalancesLiquidity[msg.sender] -= _tokens;
		etherBalancesLiquidity[msg.sender] -= _ether;


	}

	
	function withdrawAll() public {
		uint _tokens = tokenBalancesInContract[msg.sender];
		uint _ether = etherBalancesInContract[msg.sender];
		address payable _to = msg.sender;

		_to.transfer(_ether);
		tokenRMM.transfer(_to, _tokens);

		tokenBalancesInContract[msg.sender] -= _tokens;
		etherBalancesInContract[msg.sender] -= _ether;
		
	} 

}
