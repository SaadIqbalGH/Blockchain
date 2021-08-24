{\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1033{\fonttbl{\f0\fnil\fcharset0 Calibri;}}
{\colortbl ;\red0\green0\blue255;}
{\*\generator Riched20 10.0.19041}\viewkind4\uc1 
\pard\sa200\sl276\slmult1\f0\fs22\lang9 pragma solidity ^0.8.0;\par
//"SPDX-License-Identifier: UNLICENSED"\par
\par
import "{{\field{\*\fldinst{HYPERLINK https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol }}{\fldrslt{https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol\ul0\cf0}}}}\f0\fs22 ";\par
//import "{{\field{\*\fldinst{HYPERLINK https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol }}{\fldrslt{https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol\ul0\cf0}}}}\f0\fs22 ";\par
\par
interface IERC20 \{\par
\par
    function totalSupply() external view returns (uint256);\par
    function balanceOf(address account) external view returns (uint256);\par
    //function allowance(address owner, address spender) external view returns (uint256);\par
\par
    //function transfer(address recipient, uint256 amount) external returns (bool);\par
    //function approve(address spender, uint256 amount) external returns (bool);\par
    //function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\par
\par
\par
    event Transfer(address indexed from, address indexed to, uint256 value);\par
    event Approval(address indexed owner, address indexed spender, uint256 value);\par
\}\par
\par
\par
contract BasicERC20Token is IERC20 \{\par
\par
    string public constant name = "Astro Token";\par
    string public constant symbol = "AT";\par
    uint8 public  constant decimals = 18; // adopted 18 decimals and will return the total supply and other results as followed 10e18 for 1 token\par
    uint public _totalSupply;\par
    uint public Token_Sale_Lot; \par
    uint public Lot_Sell_Price;\par
    address public _Owner;\par
    uint internal numToken;\par
\par
    mapping(address => uint256) balances;\par
\par
    mapping(address => mapping (address => uint256)) allowed;\par
    event Lot_Sell_Price_Changed(address updater, uint256 newPrice);\par
    \par
    using SafeMath for uint256;\par
\par
    constructor() \{\par
         \par
        Token_Sale_Lot = 100 * (10**decimals);\par
        Lot_Sell_Price = 1 ether;\par
        _totalSupply = 1000000000 * (10**decimals);\par
        _Owner = msg.sender;\par
        balances[_Owner] = _totalSupply;\par
        emit Transfer(address(0), _Owner, _totalSupply);\par
    \}\par
\par
    modifier onlyOwner() \{\par
        require(msg.sender == _Owner, "You are not authorized");\par
        _;\par
    \}\par
    \par
    function totalSupply() public override view returns (uint256) \{\par
        return balances[_Owner];\par
    \}\par
    \par
    function balanceOf(address tokenOwner) public override view returns (uint256) \{\par
        return balances[tokenOwner];\par
    \}\par
\par
\par
    function buyToken () public payable \{\par
        require(msg.sender != _Owner);\par
        require(Lot_Sell_Price != 0 && msg.value >= Lot_Sell_Price, "Insufficient funds to buy min number of Tokens");\par
        numToken = (msg.value.mul(Token_Sale_Lot)).div(Lot_Sell_Price);\par
        //numToken = (Token_Sale_Lot * msg.value)/Lot_Sell_Price;\par
        require(numToken <= balances[_Owner]);\par
        balances[_Owner] = balances[_Owner].sub(numToken);\par
        //balances[_Owner] -= numToken;\par
        balances[msg.sender] = balances[msg.sender].add(numToken);\par
        //balances[msg.sender] += numToken;\par
        emit Transfer(_Owner, msg.sender, numToken);\par
    \}\par
   \par
    receive() external payable\{ \par
        \par
    \}\par
    \par
    function changeListPrice(uint256 _newListPrice) internal onlyOwner\{\par
\tab     Lot_Sell_Price = _newListPrice;\par
\tab     \par
\tab     emit Lot_Sell_Price_Changed(msg.sender, _newListPrice);\par
\tab\}\par
\par
    fallback() payable external\{\par
        buyToken ();\par
        \par
    \}\par
    \par
    \par
\}\par
    \par
  \par
\par
}
 