// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MoneyWallet{
    address payable public owner;
     mapping (address => bool) public isAllowedToSend;
     mapping (address => uint) public Allowance;
     mapping (address => bool) public guardians;
     address payable nextOwner;
    uint public guardiansResetCount;
    uint public constant confirmationsFromGuardiansForReset = 3;

    constructor(){
        owner = payable(msg.sender);
    }

   function setAllowance(address _from , uint _amount)public {
   require(msg.sender == owner, "You are not the owner, aborting!");
    Allowance[_from] = _amount;
    isAllowedToSend[_from] = true;

   }

   function setGuardian(address guardian)public {
    require(msg.sender == owner, "You are not the owner, aborting!");
    guardians[guardian] = true;
   }

   function proposeOwner(address payable _newOwner)public {
    require(guardians[msg.sender], "You are not a guardian, aborting!");
    if(nextOwner != _newOwner){
        nextOwner = _newOwner;
        guardiansResetCount=0;
    }
    guardiansResetCount++;

    if(guardiansResetCount >=  confirmationsFromGuardiansForReset){
        owner = nextOwner;
        nextOwner = payable (address(0));
    }
   }
   function denySending(address _from )public {
    require(msg.sender == owner, "You are not the owner, aborting!");
    isAllowedToSend[_from] = false;
   }

    function transfer(address payable _recipient, uint _amount )
    public returns (bytes memory) {
        require(_amount <= address(this).balance , 
        "Can't send more than the contract owns, aborting.");
        if(msg.sender != owner){
            require(isAllowedToSend[msg.sender],
            "You are not allowed to send any transactions, aborting");
            require(_amount <= Allowance[msg.sender] , 
            "You are trying to send more than you are allowed to, aborting");  
            Allowance[msg.sender] -= _amount;
        
        }

        (bool success , bytes memory returnData) = _recipient.call{value: _amount}("");
        require(success , "Transaction failed, aborting");
        return returnData;

    }

    receive() external payable { }
}
