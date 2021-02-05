import "./Ownable.sol";

contract ERC20 is Ownable{

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
        return( _balances[account]);
    }

    function mint(address account, uint256 amount) public onlyOwner {
        // create new tokens and put them into specified account
        uint256 originalBalance = _balances[account];
        uint256 originalTotalSupply = _totalSupply;
        
        _totalSupply += amount;
        _balances[account] += amount;
        
        //check invariants:  Start tokens + amount = new number of tokens  
        assert( (originalTotalSupply + amount) == _totalSupply );
        assert( (originalBalance + amount ) == _balances[account] );
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(_balances[msg.sender] >= amount); // sufficient funds
        uint256 sendersOriginalBalance = _balances[msg.sender];
        uint256 recipientsOriginalBalance = _balances[recipient];
        
        address payable receiver = address((uint160(recipient)));
        receiver.transfer(amount);

        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        
        //check invariant:  total balances == total orignial balances
        assert( (_balances[msg.sender] + _balances[msg.sender]) ==
                (sendersOriginalBalance + recipientsOriginalBalance));
    }
}