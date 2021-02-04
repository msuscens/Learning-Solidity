pragma solidity 0.5.12;
import "./Ownable.sol";

contract Destroyable is Ownable {
    
    function deleteContact() public onlyOwner {
        selfdestruct(msg.sender);
    }
}