pragma solidity 0.5.12;

contract HelloWorld{
    // STATE VARIABLES
    struct Person {
        string name;
        uint age;
        uint height;
        bool senior;
    }

    event personCreated(string name, bool senior);
    event personDeleted(string name, bool senior, address deletedBy);
    event personUpdated(string newName, uint newAge, uint newHeight, bool newSenior,
            string previousName, uint previousAge, uint previousHeight, bool previousSenior);

    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _; //Continue execution
    }
    
    constructor() public {
        owner = msg.sender;
    }
    
    mapping (address=>Person) private people;
    address[] private creators;

    function createPerson(string memory name, uint age, uint height) public {
        require(age <= 150, "Age must be less than or equal to 150");
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
            emit personUpdated(newPerson.name, newPerson.age, newPerson.height, newPerson.senior,
                                previous.name, previous.age, previous.height, previous.senior);
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
        
        //require(msg.sender == owner);
        string memory name = people[creator].name;
        bool senior = people[creator].senior;

        delete people[creator];
        //check invariant: people[creator].age == 0
        assert (people[creator].age == 0);
        emit personDeleted(name, senior, msg.sender);
    }
    
    function getCreator(uint index) public view onlyOwner returns(address){
        //require(msg.sender == owner);
        return creators[index];
    }
}