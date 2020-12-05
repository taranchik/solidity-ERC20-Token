pragma solidity ^0.5.8;

import "browser/ERC20.sol";

contract ZUTtoken is ERC20 {
    // Data of  the Token
    uint256 private _totalSupply;
    string public name;
    string public symbol;
    uint8 public decimals;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor() public {
        _totalSupply = 1000;
        name = "ZUTtoken";
        symbol = "ZUTtkn";
        decimals = 0;

        _balances[msg.sender] = totalSupply();
        emit Transfer(address(0), msg.sender, totalSupply());
    }

    // total amount of tokens which can be spent, when this limit will be reached, the smart contract will refuse to create new tokens
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // returns how many tokens specified address has
    function balanceOf(address _owner) public view returns (uint256) {
        return _balances[_owner];
    }

    // takes amount of tokens from msg.sender and send them to recipient
    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(
            msg.sender != address(0),
            "ERC20: transfer from the zero address"
        );
        require(recipient != address(0), "ERC20: transfer to the zero address");

        require(
            _balances[msg.sender] >= amount,
            "ERC20: amount exceeds balance"
        );
        require(amount > 0, "ERC20: amount is zero or lower");

        _balances[recipient] += amount;
        _balances[msg.sender] -= amount;

        emit Transfer(msg.sender, recipient, amount);

        return true;
    }

    // returns the amount of tokens with which spender can still withdraw from owner.
    function allowance(address owner, address spender)
        public
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    // approved spender is able to withdraw his balance so much as he want, but not more that amount
    function approve(address spender, uint256 amount) public returns (bool) {
        _allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    // transfer tokens from sender and send them to recipient
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        require(_balances[sender] >= amount, "ERC20: amount exceeds balance");
        require(
            _allowances[sender][msg.sender] >= amount,
            "ERC20: amount exceeds allowance"
        );
        require(amount > 0, "ERC20: amount is zero or lower");

        _balances[recipient] += amount;
        _balances[sender] -= amount;
        _allowances[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);

        return true;
    }
}
