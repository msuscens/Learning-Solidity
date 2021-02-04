import "./Ownable.sol";
import "./Destroyable.sol";

pragma solidity 0.5.12;

contract HelloWorld is Ownable, Destroyable{
    // STATE VARIABLES
    struct Person {
        string name;
        uint age;
        uint height;
        bool senior;
    }

    event personCreated(string name, bool senior);
    event personDeleted(string name, bool senior, address deletedBy);
    event personUpdated(string newName, uint newAge, uint newHeight,
                        bool newSenior, string previousName, uint previousAge,
                        uint previousHeight, bool previousSenior);

    uint public balance;
    
    modifier costs(uint cost){
        require(msg.value >= cost);
        _;
    }
    
    mapping (address=>Person) private people;
    address[] private creators;

    // FUNCTIONS
    function createPerson(string memory name, uint age, uint height)
                                                public payable costs(1 ether){
        require(age < 150, "Age must be less than 150");

        balance += msg.value;
        
        // Creates a new person
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        
        if (age >=  65) {
            newPerson.senior = true;
        }
        else {
            newPerson.senior = false;
        }
        
        insertPerson(newPerson);
        creators.push(msg.sender);
    }
    
    function insertPerson(Person memory newPerson) private {
        address creator = msg.sender;
        Person memory previous = people[creator];
        people[creator] = newPerson;
        //check invariant: people[msg.sender] == newPerson
        assert (
            keccak256(
                abi.encodePacked(
                    people[msg.sender].name,
                    people[msg.sender].age,
                    people[msg.sender].height,
                    people[msg.sender].senior
                )
            )
            ==
            keccak256(
                abi.encodePacked(
                    newPerson.name,
                    newPerson.age,
                    newPerson.height,
                    newPerson.senior
                )
            )
        );
        if (previous.height == 0) {
            // Previous record doesn't exist
            emit personCreated(newPerson.name, newPerson.senior);
        }
        else {
            // Previous record exists - we're updating
            emit personUpdated(newPerson.name, newPerson.age,
                            newPerson.height, newPerson.senior,
                            previous.name, previous.age,
                            previous.height, previous.senior);
        }
    }
    
    function getPerson() public view returns(string memory name, uint age,
                                            uint height, bool senior){
        return (people[msg.sender].name,
                people[msg.sender].age,
                people[msg.sender].height,
                people[msg.sender].senior);
    }
    
    function deletePerson(address creator) public onlyOwner {
        string memory name = people[creator].name;
        bool senior = people[creator].senior;

        delete people[creator];
        //check invariant: people[creator].age == 0
        assert (people[creator].age == 0);
        emit personDeleted(name, senior, msg.sender);
    }
    
    function getCreator(uint index) public view onlyOwner returns(address){
        return creators[index];
    }
    
    function withdrawAll() public onlyOwner returns(uint){
        uint toTransfer = balance;
        balance = 0;
        msg.sender.transfer(toTransfer);
        return toTransfer;
    }
 
    // Alternative version of function using msg.sender.send()
/*  function withdrawlAll() public onlyOwner returns(uint){
        uint toTransfer = balance;
        balance = 0;
        if (msg.sender.send(toTransfer)){
            //Success
            return toTransfer;
        }
        else {
            // Failure
            balance = toTransfer;
            return 0;
        }
    }
*/
}