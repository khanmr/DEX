// SPDX-License-Identifier: MIT

pragma solidity ^0.6.10;

import "./SafeYorkERC20Token.sol";

contract DEX {
    IERC20 public token;

    uint256 amount;
    uint256 balance;
    uint256 allowance;

    event Bought(uint256 amount);
    event Sold(uint256 amount);

    constructor() public {
        token = new YorkERC20Token();
    }

    function buy() public payable {
        // amount to buy
        amount = msg.value;
        // balance of tokens
        balance = token.balanceOf(address(this));
        // check if transaction amount is greater than 0
        require(amount > 0, "amount should be greater than 0");
        // check if tokens are available
        require(amount <= balance, "not enough tokens available");
        // transfer token to caller
        token.transfer(msg.sender, amount);
        // emit Transfer event
        emit token.Transfer(address(this), msg.sender, amount);
        // emit Bought event
        emit Bought(amount);
    }

    function sell(uint256 _amount) public {
        // check if amount of tokens to sell is greater than 0
        require(
            _amount > 0,
            "amount of tokens to sell has to be greater than 0"
        );
        allowance = token.allowance(msg.sender, address(this));
        // check if allowance is greater than amount of tokens to sell
        require(allowance >= _amount, "amount is less than allowance");
        // caller to approve transaction
        token.approve(msg.sender, _amount);
        // check if transfer from caller address to contract address is successful
        token.transferFrom(msg.sender, address(this), _amount);
        // send ether to caller
        msg.sender.transfer(_amount);
        // emit Transfer event
        emit token.Transfer(msg.sender, address(this), _amount);
        // emit Sold event
        emit Sold(_amount);
    }
}
