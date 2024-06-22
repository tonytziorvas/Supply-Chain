// test/UserManagement.test.js

const UserManagement = artifacts.require('UserManagement');

contract('UserManagement', (accounts) => {
    let userManagementInstance;

    before(async () => {
        userManagementInstance = await UserManagement.deployed();
    });

    it('should deploy with initial users', async () => {
        const adminRole = await userManagementInstance.getUserRole(accounts[0]);
        assert.equal(adminRole, 1, 'First account should be Administrator');

        const supplierRole = await userManagementInstance.getUserRole('0x123'); // Replace with actual supplier address
        assert.equal(supplierRole, 2, 'Supplier should have correct role');

        const logisticRole = await userManagementInstance.getUserRole('0x456'); // Replace with actual logistic address
        assert.equal(logisticRole, 3, 'Logistic Employee should have correct role');

        const inspectorRole = await userManagementInstance.getUserRole('0x789'); // Replace with actual inspector address
        assert.equal(inspectorRole, 4, 'Inspector should have correct role');
    });

    it('should not allow adding duplicate users', async () => {
        try {
            await userManagementInstance.addUser(accounts[0], 'Admin', 1); // Try adding Administrator again
            assert.fail('Should not allow adding duplicate user');
        } catch (error) {
            assert(
                error.message.includes('User already exists'),
                'Expected error message',
            );
        }
    });

    // Add more tests for adding, removing, and querying users
});
