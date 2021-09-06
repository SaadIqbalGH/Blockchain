pragma solidity ^0.8.0;
//"SPDX-License-Identifier: UNLICENSED"

/** Exercise 1: Create Data Storage Contract
- Provide a smart contract with a service to store user public bio-data which should live forever.
- Every user must pay for this service to store their data.
- If a user wants to read his public bio-data, he should put his id and get his bio-data against it.
- The contract owner should be paid by the requester who wants to save their data online. 
- The owner of the data can withdraw whatever money hhe would collect in smart contract.
- Send events on function call.
**/




contract Bio_Data_Storage {
    
    struct BioData {
        
    string first_Name;
    string last_Name;
    uint8  age;
    uint id;
    address user_add;
    
    }
    
    BioData [] private gUser;   
    
    uint public current_balance;
    
    address payable owner;
    
    event DataStorage(string);
    event WithDrawal(string,uint);
    
    constructor(){
        
        owner = payable(msg.sender);
        current_balance = 0;
    }
    
    
    function SetUserData(string calldata _fname, string calldata _lname, uint8 _age, uint _id) public payable {
        
        require (msg.value >= 100000,"Fee is less than expected, pay atleast 100,000 wei");
        current_balance += msg.value;
        
        BioData memory localObj;
        
        localObj.first_Name = _fname;
        localObj.last_Name = _lname;
        localObj.age = _age;
        localObj.id = _id;
        localObj.user_add = msg.sender;
        
        gUser.push(localObj);
        emit DataStorage("User data successfully stored.");
    }
    
    function GetUserData(uint _id) public view returns (string memory, string memory, uint8, address) {
        
        for (uint i=0; i < gUser.length; i++){
            if (_id == gUser[i].id){
                return (gUser[i].first_Name,gUser[i].last_Name,gUser[i].age,gUser[i].user_add);
            }
            
            
        }
        
    }
    
    function WithDraw() public payable{
        require (msg.sender == owner, "You are not authorized!");
        owner.transfer(address(this).balance);
        emit WithDrawal ("Amount withdrawn by owner: ", current_balance);
        current_balance =0;
    }
    
    
}