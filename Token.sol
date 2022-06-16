//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Token{

    //name of token
    string private _name;

    //symbol of token
    string private _symbol;

    //total supply of token
    uint256 private _totalSupply;

    //balance of each account
    mapping(address=>uint256) private _balances;

    //allowances to spend token on behalf of another
    mapping(address=>mapping(address=>uint256)) private _allowances;

    //transfer event
    event Transfer(address from, address to,uint256 value);

    //approval event
    event Approval(address owner, address spender, uint256 value);

    //supply token name , symbol, amount of intialsupply, minting address
    constructor(string memory name_,string memory symbol_,uint256 initialSupply,
        address owner){
        _name=name_;
        _symbol=symbol_;
        _mint(owner, initialSupply);
    }

    //returns the totalSupply amount of token
    function totalSupply()public view returns(uint256){
        return _totalSupply;
    }

    //returns the name of the token
    function name()public view returns(string memory){
        return _name;
    }

    //returns the symbol of the token
    function symbol()public view returns(string memory){
        return _symbol;
    }

    //specify the decimal value of the token 1 token = 10^18 units
    function decimals() public pure returns (uint8) {
        return 18;
    }

    //returns the balance in token of supplied address
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    //transfer the token to specified address in 'to' and amount of token as 'amount' 
    function transfer(address to,uint256 amount)public returns(bool){
        address owner=msg.sender;
        _transfer(owner,to,amount);
        return true;
    }

    //returns the amount of token spender can use on behalf of owner address
    function allowance(address owner,address spender)public view returns(uint256){
        return _allowances[owner][spender];
    }

    //approve 'spender' to use 'amount'tokens on behalf of owner 
    function approve(address spender,uint256 amount)public returns(bool){
        address owner=msg.sender;
        _approve(owner,spender,amount);
        return true;
    }

    /*transfer 'amount' tokens from address 'from' to address 'to'. For success from address must have approved 'to' address to 
     spend 'amount' tokens on his behalf*/
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    // destroy 'amount' tokens of the owner
    function burn(uint256 amount) public{
        address owner=msg.sender;
        _burn(owner, amount);
    }

    /*destroy 'amount' tokens from address 'account'. For success from address must have approved sender address to 
     spend 'amount' tokens on his behalf*/
    function burnFrom(address account, uint256 amount) public virtual {
        _spendAllowance(account,msg.sender, amount);
        _burn(account, amount);
    }

    //internal function associated with transfering the 'amount' token from address 'from' to address 'to'
    function _transfer(address from,address to,uint256 amount)internal{
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked{
        _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;
        emit Transfer(from,to,amount);
    }

    //internal function associated with approving address 'spender' to spend 'amount' token on behalf of address 'owner'
    function _approve(address owner,address spender,uint256 amount)internal{
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner,spender,amount);

    }

    //internal function associated with spending 'amount' token on behalf of address 'owner' by address 'spender'
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    //mint 'amount' tokens on address 'account'. Called initially during contract deployment
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);


    }

    
    //internal function associated with burning the token
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");


        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

    }


}