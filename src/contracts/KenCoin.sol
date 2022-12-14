pragma solidity ^0.5.0;


library SafeMath {

    function add(uint a, uint b) internal pure returns (uint c) {

        c = a + b;

        require(c >= a);

    }

    function sub(uint a, uint b) internal pure returns (uint c) {

        require(b <= a);

        c = a - b;

    }

    function mul(uint a, uint b) internal pure returns (uint c) {

        c = a * b;

        require(a == 0 || c / a == b);

    }

    function div(uint a, uint b) internal pure returns (uint c) {

        require(b > 0);

        c = a / b;

    }

}



// ----------------------------------------------------------------------------

// ERC Token Standard #20 Interface

// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md

// ----------------------------------------------------------------------------

contract ERC20Interface {

    function totalSupply() public view returns (uint);

    function balanceOf(address tokenOwner) public view returns (uint balance);

    function allowance(address tokenOwner, address spender) public view returns (uint remaining);

    function transfer(address to, uint tokens) public returns (bool success);

    function approve(address spender, uint tokens) public returns (bool success);

    function transferFrom(address from, address to, uint tokens) public returns (bool success);


    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}



// ----------------------------------------------------------------------------

// Contract function to receive approval and execute function in one call

//

// Borrowed from MiniMeToken

// ----------------------------------------------------------------------------

contract ApproveAndCallFallBack {

    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;

}



// ----------------------------------------------------------------------------

// Owned contract

// ----------------------------------------------------------------------------

contract Owned {

    address public owner;

    address public newOwner;


    event OwnershipTransferred(address indexed _from, address indexed _to);


    constructor() public {

        owner = msg.sender;

    }


    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }


    function transferOwnership(address _newOwner) public onlyOwner {

        newOwner = _newOwner;

    }

    function acceptOwnership() public {

        require(msg.sender == newOwner);

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

        newOwner = address(0);

    }

}



// ----------------------------------------------------------------------------

// @KenCoin


// variableSupply supply

// ----------------------------------------------------------------------------

contract KenCoin is ERC20Interface, Owned {

    using SafeMath for uint;


    string public symbol;

    string public  name;

    uint8 public decimals;

    uint _totalSupply;


    mapping(address => uint) balances;

    mapping(address => mapping(address => uint)) allowed;




    constructor() public  {

        symbol = "KSHC";

        name = "KenCoin";

        decimals = 18;

        _totalSupply = 0 * 10**uint(decimals);

        balances[owner] = _totalSupply;

        emit Transfer(address(0), owner, _totalSupply);

    }



    function totalSupply() public view returns (uint) {

        return _totalSupply.sub(balances[address(0)]);

    }




    function balanceOf(address tokenOwner) public view returns (uint balance) {

        return balances[tokenOwner];

    }



    function transfer(address to, uint tokens) public returns (bool success) {

        uint totalAmount = tokens;

        balances[msg.sender] = balances[msg.sender].sub(totalAmount);

        balances[to] = balances[to].add(totalAmount);

        emit Transfer(msg.sender, to, totalAmount);

        return true;

    }


    function withdraw(uint tokens) public returns (bool success){
        require(balances[msg.sender] >= tokens, "Insufficient Balance");
        require(tokens > 0, "Cannot make an empty withdrawal");

        balances[msg.sender] = balances[msg.sender].sub(tokens);
        _totalSupply = _totalSupply.sub(tokens);
        return true;
    }



    function approve(address spender, uint tokens) public returns (bool success) {
        uint totalAmount = tokens.mul(10**18);
        allowed[msg.sender][spender] = totalAmount;
        emit Approval(msg.sender, spender, totalAmount);
        return true;

    }



    function transferFrom(address from, address to, uint tokens) public returns (bool success) {

        balances[from] = balances[from].sub(tokens);

        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);

        balances[to] = balances[to].add(tokens);

        emit Transfer(from, to, tokens);

        return true;

    }



    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {

        return allowed[tokenOwner][spender];

    }



    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);

        return true;

    }

    function deposit(uint Tokens, address spender) public {

        require(msg.sender == owner, "Access denied for non owners");
        _totalSupply += Tokens;
        balances[spender] += Tokens;
    }


//    function withdraw(uint amount, address spender) public {
//        require(msg.sender == owner);
//
//        require(balances[spender] > amount );
//
//        balances[spender] -= amount;
//
//        _totalSupply -= amount;
//    }



    function () external payable {
        revert();
    }




    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {

        return ERC20Interface(tokenAddress).transfer(owner, tokens);

    }

}


//Address = 0x081a27f4eb8aa88984e0cb749f88a4188f3c03fb (Rinkeby Test Net)
