// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract RZNToken is IERC20 {
    string public name = "Cure Earth RZN";
    string public symbol = "RZN";
    uint8 public decimals = 18;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor() {
        // 1 Milyar adet RZN Token üretimi ve cüzdanına aktarımı
        _totalSupply = 1000000000 * 10**uint256(decimals);
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        address owner = msg.sender;
        require(_balances[owner] >= value, "ERC20: transfer amount exceeds balance");
        _balances[owner] -= value;
        _balances[to] += value;
        emit Transfer(owner, to, value);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) public override returns (bool) {
        address owner = msg.sender;
        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        address spender = msg.sender;
        require(_allowances[from][spender] >= value, "ERC20: insufficient allowance");
        require(_balances[from] >= value, "ERC20: transfer amount exceeds balance");
        _allowances[from][spender] -= value;
        _balances[from] -= value;
        _balances[to] += value;
        emit Transfer(from, to, value);
        return true;
    }

    function burn(uint256 value) public {
        address owner = msg.sender;
        require(_balances[owner] >= value, "ERC20: burn amount exceeds balance");
        _balances[owner] -= value;
        _totalSupply -= value;
        emit Transfer(owner, address(0), value);
    }
}
