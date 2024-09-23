// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartMoneyWallet{

     //function to check contract balance
     function getContractBalance()public view returns (uint) {
        return address(this).balance;
     }

     // function for amout deposit
    function deposit() public  payable {
        require(msg.value > 0 , "Enter money to deposit.");
        
    }

        // function to withdraw amount
    function withDraw()public payable {
         uint contractBalance = address(this).balance;
        require(contractBalance  > 0 , "the contract has no balance!");
        payable(msg.sender).transfer( contractBalance );
      
    }

        // function to send amount to specific address
    function sendToAddress(address payable to)public{
         require(address(this).balance > 0 , "the contract has no balance!");
         to.transfer(address(this).balance);
    }


}