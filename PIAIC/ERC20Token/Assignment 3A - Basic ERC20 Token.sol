pragma solidity ^0.8.0;
//"SPDX-License-Identifier: UNLICENSED"

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    //function allowance(address owner, address spender) external view returns (uint256);

    //function transfer(address recipient, uint256 amount) external returns (bool);
    //function approve(address spender, uint256 amount) external returns (bool);
    //function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract BasicERC20Token is IERC20 {

    string public constant name = "Astro Token";
    string public constant symbol = "AT";
    uint8 public  constant decimals = 18; // adopted 18 decimals and will return the total supply and other results as followed 10e18 for 1 token
    uint public _totalSupply;
    uint public Token_Sale_Lot; 
    uint public Lot_Sell_Price;
    address public _Owner;
    uint internal numToken;

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;
    event Lot_Sell_Price_Changed(address updater, uint256 newPrice);
    
    using SafeMath for uint256;

    constructor() {
         
        Token_Sale_Lot = 100 * (10**decimals);
        Lot_Sell_Price = 1 ether;
        _totalSupply = 1000000000 * (10**decimals);
        _Owner = msg.sender;
        balances[_Owner] = _totalSupply;
        emit Transfer(address(0), _Owner, _totalSupply);
    }

    modifier onlyOwner() {
        require(msg.sender == _Owner, "You are not authorized");
        _;
    }
    
    function totalSupply() public override view returns (uint256) {
        return balances[_Owner];
    }
    
    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }


    function buyToken () public payable {
        require(msg.sender != _Owner);
        require(Lot_Sell_Price != 0 && msg.value >= Lot_Sell_Price, "Insufficient funds to buy min number of Tokens");
        numToken = (msg.value.mul(Token_Sale_Lot)).div(Lot_Sell_Price);
        //numToken = (Token_Sale_Lot * msg.value)/Lot_Sell_Price;
        require(numToken <= balances[_Owner]);
        balances[_Owner] = balances[_Owner].sub(numToken);
        //balances[_Owner] -= numToken;
        balances[msg.sender] = balances[msg.sender].add(numToken);
        //balances[msg.sender] += numToken;
        emit Transfer(_Owner, msg.sender, numToken);
    }
   
    receive() external payable{ 
        
    }
    
    function changeListPrice(uint256 _newListPrice) internal onlyOwner{
	    Lot_Sell_Price = _newListPrice;
	    
	    emit Lot_Sell_Price_Changed(msg.sender, _newListPrice);
	}

    fallback() payable external{
        buyToken ();
        
    }
    
    
}
    
  

