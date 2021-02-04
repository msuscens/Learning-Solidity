import "./People.sol";
import "./Ownable.sol";

pragma solidity 0.5.12;

contract Workers is People{
    // STATE VARIABLES
    mapping (address=>uint) private salary;
    address public boss;

    modifier onlyBoss() {
        require(msg.sender == boss);
        _; //Continue execution
    }
    
    constructor() public {
        // Assume only the boss can hire a worker (i.e. create a worker)
        boss = msg.sender;
    }

    //FUNCTIONS
    function createWorker(string memory name, uint age, uint height, uint annualSalary) public payable costs(100 wei){
        require(age <= 75, "Worker must be no older than 75 years");
        salary[msg.sender] = annualSalary;
        createPerson(name, age, height);
    }
    
    function fire() public onlyBoss {
        //deletePerson(msg.sender);  // only works if boss is also the contract owner!?
        removePerson(msg.sender);
        delete(salary[msg.sender]);
    }
}