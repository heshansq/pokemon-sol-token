// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./Token.sol";
import "./BaseToken.sol";

contract PokemonTDToken {

    Token public token;
    uint256 uintOfEthCanBuy;

    event Bought(uint256 amount);
    event Sold(uint256 amount);

    constructor() {
        token = new BaseToken();
        uintOfEthCanBuy = 10000;
    }

    function buy() payable public {
        uint256 amountBuy = msg.value;
        uint256 pkBalance = token.balanceOf(address(this));

        uint256 amountBuyTokenSize = msg.value * uintOfEthCanBuy;

        require(amountBuy > 0, "You need to mention Ether to buy");
        require(amountBuyTokenSize <= pkBalance, "Not Enough PokemonTD Left");

        token.transfer(msg.sender, amountBuyTokenSize);
        token.transferEthToOwner(amountBuy);
        emit Bought(amountBuyTokenSize);
    }

    function sell(uint256 _amount) public {
        require(_amount > 0, "You need to mention PokemonTD amount");
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance > _amount, "Please check the token allowance");
        token.transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(_amount);
        emit Sold(_amount);
    }

}