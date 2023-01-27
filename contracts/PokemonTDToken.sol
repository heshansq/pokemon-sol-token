// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./Token.sol";
import "./BaseToken.sol";

contract PokemonTDToken {

    Token public token;
    uint256 uintOfEthCanBuy;
    address payable ownerWallet;

    event Bought(uint256 amount);
    event Sold(uint256 amount);
    ReturnOption returnOption;

    constructor() {
        token = new BaseToken();
        uintOfEthCanBuy = 1000;
        ownerWallet = payable(msg.sender);
    }

    function buy() payable public {
        uint256 amountBuy = msg.value;
        uint256 pkBalance = token.balanceOf(address(this));

        uint256 amountBuyTokenSize = msg.value * uintOfEthCanBuy;

        require(amountBuy > 0, "You need to mention Ether or Wei to buy");
        require(amountBuyTokenSize <= pkBalance, "Not Enough PokemonTD Left");

        token.transfer(msg.sender, amountBuyTokenSize);
        ownerWallet.transfer(amountBuy);
        //payable()
        //token.transferEthToOwner(amountBuy);
        emit Bought(amountBuyTokenSize);
    }

    function sell(uint256 _amount) public {
        require(_amount > 0, "You need to mention PokemonTD amount");
        //uint256 allowance = token.allowance(msg.sender, address(this));
        //require(allowance > _amount, "Please check the token allowance");
        token.transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(_amount);
        emit Sold(_amount);
    }

    struct ReturnOption {
        uint256 amount;
        uint256 balance;
    }

    function getAmountCheck() payable public returns(uint256 amount) {
        uint256 pkBalance = token.balanceOf(address(this));

        returnOption = ReturnOption({balance:pkBalance, amount:msg.value });
        return msg.value;
    }

    function currentBalance() public returns(uint256 balance) {
        return token.balanceOf(msg.sender);
    }

}