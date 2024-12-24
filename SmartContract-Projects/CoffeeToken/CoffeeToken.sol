// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// Import ERC20 token standard and AccessControl for role-based permissions
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol";

contract CoffeeToken is ERC20, AccessControl {
    // Define the MINTER_ROLE for minting permissions
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    // Event to log coffee purchases
    event coffeePurchased(address indexed buyer, address indexed receiver);

    // Constructor sets token name, symbol, and grants roles to the deployer
    constructor() ERC20("CoffeeToken", "CFT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); // Admin role
        _grantRole(MINTER_ROLE, msg.sender);       // Minter role
    }

    // Mint tokens to a specified address (only for MINTER_ROLE)
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount * 10 ** decimals());
    }

    // Burn 1 token from the caller's balance to "buy" a coffee
    function BuyOneCoffee() public {
        _burn(_msgSender(), 1 * 10 ** decimals());
        emit coffeePurchased(_msgSender(), _msgSender());
    }

    // Burn 1 token from another user using allowance
    function buyOneCoffeeFrom(address account) public {
        _spendAllowance(account, _msgSender(), 1 * 10 ** decimals());
        _burn(account, 1 * 10 ** decimals());
        emit coffeePurchased(_msgSender(), account);
    } 
}
