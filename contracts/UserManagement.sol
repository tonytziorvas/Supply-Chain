// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserManagement {
    uint constant NONE = 0;
    uint constant SUPPLIER = 1;
    uint constant LOGISTIC = 2;
    uint constant INSPECTOR = 3;
    uint constant ADMIN = 4;

    struct User {
        uint id; // Unique identifier for the user
        string name; // User's name
        uint role; // User's role
    }

    mapping(address => User) public users; // Mapping from address to User
    address[] public userAddresses; // Array to store user addresses
    uint256 public userCount = 0; // Count of users
    

    // Events for user management
    event UserAdded(address indexed userAddress, uint id, string name, uint role);
    event UserRemoved(address indexed userAddress);

    // Constructor to initialize the contract with an admin user
    constructor(string memory adminName) {
        userCount++;
        users[msg.sender] = User(userCount, adminName, ADMIN);
        userAddresses.push(msg.sender);
        emit UserAdded(msg.sender, userCount, adminName, ADMIN);
    }

    function addUser(
        address _userAddress,
        string memory _name,
        uint _role
    ) public onlyAdmin {
        require(users[_userAddress].role == NONE, 'User already exists');
        userCount++;
        users[_userAddress] = User(userCount, _name, _role);
        userAddresses.push(_userAddress);
        emit UserAdded(_userAddress, userCount, _name, _role);
    }

    function removeUser(address _userAddress) public onlyAdmin {
        require(users[_userAddress].role != NONE, 'User does not exist');
        delete users[_userAddress];

        // Remove user address from the array
        for (uint i = 0; i < userAddresses.length; i++) {
            if (userAddresses[i] == _userAddress) {
                userAddresses[i] = userAddresses[userAddresses.length - 1];
                userAddresses.pop();
                break;
            }
        }
        emit UserRemoved(_userAddress);
    }

    function getAllUsers() public view returns (User[] memory) {
        User[] memory allUsers = new User[](userAddresses.length);
        for (uint i = 0; i < userAddresses.length; i++) {
            allUsers[i] = users[userAddresses[i]];
        }
        return allUsers;
    }

    function getUserRole(address _userAddress) public view returns (uint) {
        return users[_userAddress].role;
    }

    function getUserCount() public view returns (uint256) {
        require(
            users[msg.sender].role >= INSPECTOR,
            'Access restricted to Inspectors and above'
        );
        return userCount;
    }

    // MODIFIERS
    modifier onlyAdmin() {
        require(users[msg.sender].role == ADMIN, 'Only admin can perform this action');
        _;
    }

    modifier onlySupplier() {
        require(
            users[msg.sender].role == SUPPLIER,
            'Only suppliers can perform this action'
        );
        _;
    }

    modifier onlyLogistic() {
        require(
            users[msg.sender].role >= LOGISTIC,
            'Access restricted to Logistic employees'
        );
        _;
    }

    modifier onlyInspector() {
        require(users[msg.sender].role == INSPECTOR, 'Access restricted to Inspectors');
        _;
    }
}
