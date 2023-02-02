// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./Token.sol";
import "./BaseToken.sol";

contract PokemonTDToken {

    Token public token;
    uint256 uintOfEthCanBuy;
    address payable ownerWallet;
    address ownerWalletN;

    event Bought(uint256 amount);
    event Sold(uint256 amount);

    constructor() {
        token = new BaseToken();
        uintOfEthCanBuy = 10000;
        ownerWallet = payable(msg.sender);
        ownerWalletN = msg.sender;
    }

    /*
    * Buy Tokens from original wallet
    */
    function buy() payable public {
        uint256 amountBuy = msg.value;
        uint256 pkBalance = token.balanceOf(address(this));

        uint256 amountBuyTokenSize = msg.value;

        require(amountBuy > 0, "You need to mention Ether or Wei to buy");
        require(amountBuyTokenSize <= pkBalance, "Not Enough PokemonTD Left");

        token.transfer(msg.sender, amountBuyTokenSize);
        ownerWallet.transfer(amountBuy);
        emit Bought(amountBuyTokenSize);
    }

    /*
    * Sell Tokens from owner to original wallet
    */
    function sell(uint256 _amount) payable public {
        require(_amount > 0, "You need to mention PokemonTD amount");
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance > _amount, "Please check the token allowance");
        token.transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(_amount / uintOfEthCanBuy);
        emit Sold(_amount / uintOfEthCanBuy);
    }

    /*
    * Transfer a token to winner. If looser dont have tokens, the token will be transferred from the 
    * original wallet
    */
    function transferSingleTokenToWinner(address _to, address _from, uint256 _amount) public returns(uint256 balance) {
        require(_amount > 0, "You need to mention PokemonTD amount");

        uint256 balanceFromUser = token.balanceOf(_from);
        if (balanceFromUser >= _amount) {
            token.transferFrom(_from, _to, _amount);
        } else {
            token.transfer(_to, _amount);
        }
        
        uint256 balanceFromUserFinal = token.balanceOf(_from);

        return balanceFromUserFinal;
    }

    function transferSingleTokenToWinnerWithSpender(address _to, address _from, address _spender, uint256 _amount) public returns(uint256 balance) {
        require(_amount > 0, "You need to mention PokemonTD amount");

        uint256 balanceFromUser = token.balanceOf(_from);
        if (balanceFromUser >= _amount) {
            token.transferFromWithSpender(_from, _to, _spender, _amount);
        } else {
            token.transfer(_to, _amount);
        }
        
        uint256 balanceFromUserFinal = token.balanceOf(_from);

        return balanceFromUserFinal;
    }

    function approveSpenderSection(address _spender, uint256 _value) public returns(uint256 balance) {
        token.approve(_spender, _value);
        return token.allowance(msg.sender, _spender);
    }

    function approveSpenderFromOwner(address _owner, address _spender, uint256 _value) public returns(uint256 balance) {
        token.approveSpender(_spender, _owner, _value);(_spender, _owner, _value);
        return token.allowance(_owner, _spender);
    }

    function getAllowance(address _owner, address _spender) public returns(uint256 balance) {
        return token.allowance(_owner, _spender);
    }

    /*
    * get balance of original wallet
    */
    function getAmountCheck() payable public returns(uint256 amount) {
        uint256 pkBalance = token.balanceOf(address(this));
        return pkBalance;
    }

    /*
    * get balance of current user
    */
    function currentBalance() public view returns(uint256 balance) {
        return token.balanceOf(msg.sender);
    }

    /*
    * get balance of a user
    */
    function currentBalanceUser(address _useraddress) public view returns(uint256 balanceData) {
        return token.balanceOf(_useraddress);
    }

    function decimals() public view returns (uint8) {
        return token.decimals();
    }

    function name() public view returns (string memory) {
        return token.name();
    }

    function symbol() public view returns (string memory) {
        return token.symbol();
    }

    function balanceOf(address _owner) public view returns(uint256 _balance) {
        return token.balanceOf(_owner);
    }

}