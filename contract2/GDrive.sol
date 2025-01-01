// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GDrive{

    mapping (address => Access[]) accessList;
    mapping (address => string[]) Data;
    mapping (address => mapping (address => bool)) ownership;
    mapping(address => mapping (address => bool)) previousData;   
    struct Access{
        address user;
        bool access; 
        
    }

    function addData(address user, string memory url) external {
      Data[user].push(url);
    }

    function allowUser(address _user)public {
        ownership[msg.sender][_user] = true;
        for(uint i=0; i<accessList[msg.sender].length; i++){
            if(accessList[msg.sender][i].user ==_user){
          accessList[msg.sender][i].access = true;

            }
        }
        accessList[msg.sender].push(Access(_user, true));
        previousData[msg.sender][_user]= true;

        
    }


    function disAllowUser(address _user)public{
        ownership[msg.sender][_user] = false;
        for(uint i=0; i<accessList[msg.sender].length; i++){
            if(accessList[msg.sender][i].user == _user){
                 accessList[msg.sender][i].access=false;  
                
            }
        }
           }


  
    function displayData(address _user)external view  returns(string[] memory) {
      require(_user == msg.sender || ownership[_user][msg.sender],"You are not authorized, aborting!");
      return Data[_user];
    }

    function shareAccess()public view returns(Access[] memory){
        return accessList[msg.sender];
    }
}