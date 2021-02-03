pragma solidity 0.5.12;

contract People{
    struct Person {
        uint id;
        string name;
        uint age;
        uint height;
        bool senior;
        address creator;
    }
    
    Person[] private people;
    mapping (address => uint) private numPeopleCreatedByAddress;
    mapping (address => uint[]) private peopleCreatedByAddress;

    function createPerson(string memory name, uint age, uint height) public {
        Person memory newPerson;
        newPerson.id = people.length;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        if (age >=  65) {
            newPerson.senior = true;
        }
        else {
            newPerson.senior = false;
        }
        newPerson.creator = msg.sender;
        
        people.push( newPerson );
        numPeopleCreatedByAddress[msg.sender] = numPeopleCreatedByAddress[msg.sender] + 1;
        peopleCreatedByAddress[msg.sender].push(newPerson.id);
    }
    
    function getPerson(uint index) public view
                returns(uint id, string memory name,
                        uint age, uint height, bool senior, address creator){
        return (people[index].id,
                people[index].name,
                people[index].age,
                people[index].height,
                people[index].senior,
                people[index].creator);
    }
    
    function getNumberPersonsCreatedByMsgSender() public view
                                            returns (uint numberPersons) {
        return (numPeopleCreatedByAddress[msg.sender]);            
    }
    
    function getPersonIdsCreatedByMsgSender() public view returns(uint[] memory) {
      return peopleCreatedByAddress[msg.sender];
    }
}