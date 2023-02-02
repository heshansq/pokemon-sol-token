// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./Token.sol";
import "hardhat/console.sol";

contract BaseToken is Token {

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    uint256 public totalSupplyVal;
    string public _name;
    string public _symbol;
    string public version = "1.0";
    address payable public fundsWallet;
    uint256 uintOfEthCanBuy;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor() {
        totalSupplyVal = 100 ether;
        fundsWallet = payable(msg.sender);
        balances[fundsWallet] = totalSupplyVal;
        _name = "PokemonTD";
        _symbol = "PKTD";
        uintOfEthCanBuy = 10000;
    }

    function transfer(address _to, uint256 _value) public override returns (bool success) {
        require(_value > 0, "value is lower than 1, you cant transfer");
        require(balances[msg.sender] >= _value ,"sender value needs to be higher than sending value");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        allowed[_to][msg.sender] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function totalSupply() public override view returns (uint256 supply) {
        return totalSupplyVal;
    }

    function transferEthToOwner(uint256 _amount) public payable override returns (bool success) {
        fundsWallet.transfer(_amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns(bool success) {
        require(_value > 0, "value is lower than 1, you cant transfer");
        require(balances[_from] >= _value ,"sender value needs to be higher than sending value");

        balances[_from] -= _value;
        balances[_to] += _value;

        //check a way to implement struct here
        allowed[_from][_to] -= _value;
        emit Transfer(_from, _to, _value);

        return true;
    }

    function transferFromWithSpender(address _from, address _to, address _spender, uint256 _value) public override returns(bool success) {
        require(_value > 0, "value is lower than 1, you cant transfer");
        require(balances[_from] >= _value ,"sender value needs to be higher than sending value");
        require(allowed[_from][_spender] >= _value, "allowed value criteria never met");

        balances[_from] -= _value;
        balances[_to] += _value;

        //check a way to implement struct here
        allowed[_from][_spender] -= _value;
        emit Transfer(_from, _to, _value);

        return true;
    }

    function balanceOf(address _owner) public view override returns(uint256 _balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public override returns(bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function approveSpender(address _spender, address _owner, uint256 _value) public override returns(bool success) {
        allowed[_owner][_spender] = _value;
        emit Approval(_owner, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public override view returns(uint256 remaining){
        return allowed[_owner][_spender];
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

}