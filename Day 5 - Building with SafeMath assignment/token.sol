pragma solidity 0.5.12;
import "./Ownable.sol";

import "Safemath.sol";

contract ERC20 is Ownable{

    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }


    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) public view returns (uint256) {
        return (_balances[account]);
    }

    function mint(address account, uint256 amount) public onlyOwner {
        // create new tokens and put them into specified account
        require(account != address(0), "Abandoned mint to zero address!");
        
        uint256 originalBalance = _balances[account];
        uint256 originalTotalSupply = _totalSupply;
        
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        
        //check invariants:  Start tokens + amount = new number of tokens  
        assert( (originalTotalSupply.add(amount)) == _totalSupply );
        assert( (originalBalance.add(amount)) == _balances[account] );
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "Won't transfer to zero address!");
        require(_balances[msg.sender] >= amount, "Balance insufficient for transfer amount!");
        
        uint256 sendersOriginalBalance = _balances[msg.sender];
        uint256 recipientsOriginalBalance = _balances[recipient];

        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        
        //check invariant:  total balances == total orignial balances
        assert( (_balances[msg.sender].add(_balances[recipient])) ==
                (sendersOriginalBalance.add(recipientsOriginalBalance)) );
                
        return true;
    }
}