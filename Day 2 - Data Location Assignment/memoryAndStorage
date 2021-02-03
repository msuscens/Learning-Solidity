contract MemoryAndStorage {

    mapping(uint => User) users;

    struct User{
        uint id;
        uint balance;
    }

    function addUser(uint id, uint balance) public {
        users[id] = User(id, balance);
    }

    function updateBalance(uint id, uint balance) public {
  // Error in this function's code, as that:
  // 1. It takes a copy of users[id] and then updates this copy.
  // The original mapping value is not updated and so the balance
  // remains the same (in the mapping).
  // 2. Furthermore, the memory variable user is only saved for 
  // the duration of the function execution.  And so the copy of
  // users[id], with the updated balance, is lost after each execution.

  //       User memory user = users[id];
  //       user.balance = balance;
  
  // Replacement corrrect code line is:
           users[id].balance = balance;
    }

    function getBalance(uint id) view public returns (uint) {
        return users[id].balance;
    }

}

