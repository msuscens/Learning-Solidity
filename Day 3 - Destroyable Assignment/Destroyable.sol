pragma solidity 0.5.12;

contract Destroyable {
    
    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _; //Continue execution
    }
    
    constructor() public {
        owner = msg.sender;
    } 
    
    function deleteContact() public onlyOwner {
        //require(msg.sender == owner);
        selfdestruct(msg.sender);
    }
}