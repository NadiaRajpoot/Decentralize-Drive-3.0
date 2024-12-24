// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// Interface for interacting with ERC20 tokens
interface IERC20 {
    // Function to transfer tokens from one address to another
    function transferFrom(address from, address to, uint amount) external;
    
    // Function to return the token's decimal places
    function decimals() external view returns(uint8);
}
 
contract TokenSale {
    uint public tokenPriceInWei = 1 ether;  // Price of one token in Wei (1 token = 1 Ether)

    IERC20 Token;  // Declare the ERC20 token interface
    address public TokenOwner;  // Store the address of the token owner

    // Constructor sets the token contract address and assigns ownership
    constructor(address _token) {
        TokenOwner = msg.sender;  // Assign deployer as the token owner
        Token = IERC20(_token);   // Initialize token interface with the provided token address
    }

    // Purchase function: Allows users to buy tokens
    function purchase() public payable {
        // Check if enough Ether is sent for at least one token
        require(msg.value >= tokenPriceInWei, "Not enough money sent");

        // Calculate how many tokens to send based on the value of Ether sent
        uint tokenToSent = msg.value / tokenPriceInWei;

        // Calculate the remainder (if any) after token purchase
        uint remainder = msg.value - tokenToSent * tokenPriceInWei;

        // Transfer the calculated amount of tokens from the owner to the buyer
        Token.transferFrom(TokenOwner, msg.sender, tokenToSent * 10 ** Token.decimals());

        // Refund any remaining Ether to the sender
        payable(msg.sender).transfer(remainder);
    }
}
