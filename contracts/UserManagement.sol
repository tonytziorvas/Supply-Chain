// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserManagement {
    struct User {
        string name;
        uint8 role;
    }

    mapping(address => User) public users;
    address[] public userAddresses;
    uint256 public userCount = 0;

    // Role constants
    uint8 constant SUPPLIER = 1;
    uint8 constant LOGISTIC_EMPLOYEE = 2;
    uint8 constant INSPECTOR = 3;
    uint8 constant ADMINISTRATOR = 4;

    // Events for user management
    event UserAdded(address indexed userAddress, string name, uint8 role);
    event UserRemoved(address indexed userAddress);

    // Constructor to create initial users
    constructor() {
        // Add Administrator
        addUser(msg.sender, 'Admin', ADMINISTRATOR);

        // Add Supplier
        address supplierAddress = address(0x123); // Example address
        addUser(supplierAddress, 'Supplier1', SUPPLIER);

        // Add Logistic Employee
        address logisticAddress = address(0x456); // Example address
        addUser(logisticAddress, 'Logistic1', LOGISTIC_EMPLOYEE);

        // Add Inspector
        address inspectorAddress = address(0x789); // Example address
        addUser(inspectorAddress, 'Inspector1', INSPECTOR);
    }

    // Add User
    function addUser(
        address _userAddress,
        string memory _name,
        uint8 _role
    ) public onlyAdmin {
        require(_role > 0 && _role <= ADMINISTRATOR, 'Invalid role');
        users[_userAddress] = User(_name, _role);
        userAddresses.push(_userAddress);
        userCount++;
        emit UserAdded(_userAddress, _name, _role);
    }

    // Remove User
    function removeUser(address _userAddress) public onlyAdmin {
        require(users[_userAddress].role != 0, 'User does not exist');
        delete users[_userAddress];
        emit UserRemoved(_userAddress);
    }

    // Get User Role
    function getUserRole(address _userAddress) public view returns (uint8) {
        return users[_userAddress].role;
    }

    // Get User Count
    function getUserCount() public view returns (uint256) {
        return userCount;
    }

    // Get All Users
    function getAllUsers() public view returns (address[] memory) {
        return userAddresses;
    }

    // Modifiers
    modifier onlyAdmin() {
        require(
            users[msg.sender].role == ADMINISTRATOR,
            'Access denied: Only Administrator can perform this action'
        );
        _;
    }

    modifier onlySupplierOrAbove() {
        require(
            users[msg.sender].role >= SUPPLIER,
            'Access denied: Only Supplier or above can perform this action'
        );
        _;
    }
    modifier onlySupplier() {
        require(
            users[msg.sender].role == SUPPLIER,
            'Access denied: Only Supplier can add products'
        );
        _;
    }

    modifier onlyLogisticOrAbove() {
        require(
            users[msg.sender].role >= LOGISTIC_EMPLOYEE,
            'Access denied: Only Logistic Employee or above can perform this action'
        );
        _;
    }

    modifier onlyInspector() {
        require(
            users[msg.sender].role >= INSPECTOR,
            'Access denied: Only Inspector or above can perform this action'
        );
        _;
    }
}
