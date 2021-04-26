/** saylani wants you to create a contract for free blockchain certification, and these are requirements
1: we want to raise 10 ethers in our contract and after completing the fund's raising, we can destroy this contract .
2 : when we destroy the contract funds (ether) should be transferred to our given account**/

// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.0;

contract BCCampaign {

modifier verifyBalance(){
    address payable addr  = payable(address(0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC)); 
    if (address(this).balance >= 10000000000000000000 wei){
    selfdestruct(addr);
        _;
        }
    }
  
function ReceivePayment() verifyBalance() public payable {
    
    }

function CheckBalance() public view returns (uint) {
    return address(this).balance; 
    }
}