pragma solidity ^0.8.0;
//"SPDX-License-Identifier: UNLICENSED"

/**
- Dedicated to two organizations as a one-time contract
- Store buyer and seller addresses
- The buyer must escrow his amount on the smart cotract; also, he must have the power to release these payments to seller
- The seller must indicate if he has shipped the item requested; if yes, then take the date from him with the shipment number
- Show events and maintain the status of this whole business like 'waiting for package', 'amount escrowed' etc.
**/

contract Escrow_Service {
    
    enum Statuses {WAITING_FOR_DEPOSIT, DEPOSIT_CONFIRMED, SHIPMENT_IN_PROCESS, SHIPMENT_RECEIVED, PAYMENT_RELEASED}
    uint private payment_agreed;
    address private buyer;
    address payable private seller;
    Statuses status;
    
    constructor (address _buyer, address payable _seller, uint _agreed){
        buyer = _buyer;
        seller = _seller;
        payment_agreed = _agreed;
        status = Statuses.WAITING_FOR_DEPOSIT;
    }
    
    modifier onlyBuyer(){
        require(msg.sender == buyer,"Hold on you are not authentic buyer");
        _;
    }
    
        modifier onlySeller(){
        require(msg.sender == seller,"You are not the seller, please go away");
        _;
    }
    
    event DepositConfirmed(uint value, string msg);
    event ReleaseConfirmed(string msg);

    
    function getStatus() public view returns (Statuses state)
    {
        return status;
    }
    
    function deposit() external payable onlyBuyer {

	require(payment_agreed == msg.value,"Your amount is not same as agreed amount");
	status = Statuses.DEPOSIT_CONFIRMED;
	
	emit DepositConfirmed(msg.value, "Good! deposit is here inside the contract");
    
    }
    
    function ShipmentInProgress() external onlySeller {

	    status = Statuses.SHIPMENT_IN_PROCESS;
    
    }
    
    function ShipmentReceived() external onlyBuyer {

	    status = Statuses.SHIPMENT_RECEIVED;
    
    }
    
    function ReleasePayment() external onlyBuyer payable{
        
        seller.transfer(address(this).balance);
	    status = Statuses.PAYMENT_RELEASED;
	    emit ReleaseConfirmed("Thank you! payment received as agreed.");
    }
    
}