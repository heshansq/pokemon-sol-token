// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
* Base ERC-20 Token Standard Interface
*/
interface Token {
    function totalSupply() external returns (uint256 supply);
    function balanceOf(address _owner) external returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function transferFromWithSpender(address _from, address _to, address _spender, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function approveSpender(address _spender, address _owner, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external returns (uint256 remaining);
    function transferEthToOwner(uint256 _amount) external payable returns (bool success);
    function decimals() external view returns (uint8);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
}