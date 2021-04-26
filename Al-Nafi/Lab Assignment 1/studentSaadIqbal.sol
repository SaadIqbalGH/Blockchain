
//SPDX-License-Identifier: Undefined
pragma solidity >=0.4.22 <0.9.0;

contract studentSaadIqbal {

int private roll_number;
string private name;
bool private is_registered;
bool private is_fee_paid;

function setUserInfo(int _roll_number, string calldata _name, bool _registered, bool _fee_paid) public {
    roll_number = _roll_number;
    name = _name;
    is_registered = _registered;
    is_fee_paid = _fee_paid;

}

function getUserInfo () public view returns (int, string memory, bool, bool) {

    return (roll_number, name, is_registered, is_fee_paid);
}

}