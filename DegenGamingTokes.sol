// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DegenGamingToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;
    mapping(address => bool) private isAdmin;
    mapping(address => uint256) private rewards;
    // like a watch on spending limit by current owner 

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event RewardAdded(address indexed admin, uint256 amount);
    event RewardClaimed(address indexed player, uint256 amount);

    //  it creates a log entry on the blockchain.
    // help to track when and where token is used by an external user 

    constructor() {
        name = "Degen Token";
        symbol = "DGN";
        decimals = 18;
        totalSupply = 0;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    function mint(address account, uint256 amount) external onlyOwner {
        require(account != address(0), "Invalid address");
        require(amount > 0, "Invalid amount");

        balances[account] += amount;
        totalSupply += amount;

        emit Transfer(address(0), account, amount);
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        require(recipient != address(0), "Invalid address");
        require(amount > 0, "Invalid amount");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "Invalid address");

        allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        require(sender != address(0), "Invalid address");
        require(recipient != address(0), "Invalid address");
        require(amount > 0, "Invalid amount");
        require(amount <= balances[sender], "Insufficient balance");
        require(amount <= allowances[sender][msg.sender], "Insufficient allowance");

        balances[sender] -= amount;
        balances[recipient] += amount;
        allowances[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    function burn(uint256 amount) external {
        require(amount > 0, "Invalid amount");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    function claimReward() external returns (uint256) {
    uint256 amount = rewards[msg.sender];
    require(amount > 0, "No rewards to claim");

    rewards[msg.sender] = 0;

    // Perform the reward distribution logic here

    emit RewardClaimed(msg.sender, amount);

    return amount;
}

    function InGamePurchase(uint256 amount) external {
    require(amount > 0, "Invalid amount");
    require(amount <= balances[msg.sender], "Insufficient balance");
    

    balances[msg.sender] -= amount;
    totalSupply -= amount;

    emit Transfer(msg.sender, address(0), amount);
}

}
