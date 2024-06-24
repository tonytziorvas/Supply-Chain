const UserManagement = artifacts.require('UserManagement');

contract('UserManagement', (accounts) => {
    let userManagement;
    const [deployer, user1, user2] = accounts;

    before(async () => {
        userManagement = await UserManagement.new('Admin');
    });

    it('should deploy with the initial admin user', async () => {
        const adminUser = await userManagement.users(deployer);
        assert(adminUser.id.toNumber() === 1, 'Admin user ID should be 1');
        assert(adminUser.name === 'Admin', "Admin user name should be 'Admin'");
        assert(adminUser.role.toNumber() === 4, 'Admin user role should be ADMIN (4)');
    });

    it('should add a new user by admin', async () => {
        await userManagement.addUser(user1, 'Supplier1', 1, { from: deployer });
        const addedUser = await userManagement.users(user1);
        assert(addedUser.id.toNumber() === 2, 'New user ID should be 2');
        assert(addedUser.name === 'Supplier1', "New user name should be 'Supplier1'");
        assert(addedUser.role.toNumber() === 1, 'New user role should be SUPPLIER (1)');
    });

    it('should not add a new user by non-admin', async () => {
        try {
            await userManagement.addUser(user2, 'Logistic1', 2, { from: user1 });
            assert.fail('Non-admin should not be able to add a user');
        } catch (error) {
            assert(
                error.message.includes('Only admin can perform this action'),
                'Expected admin restriction error',
            );
        }
    });

    it('should remove a user by admin', async () => {
        await userManagement.removeUser(user1, { from: deployer });
        const removedUser = await userManagement.users(user1);
        assert(removedUser.role.toNumber() === 0, "Removed user's role should be NONE (0)");
    });

    it('should not remove a user by non-admin', async () => {
        await userManagement.addUser(user1, 'Supplier1', 1, { from: deployer });
        try {
            await userManagement.removeUser(user1, { from: user1 });
            assert.fail('Non-admin should not be able to remove a user');
        } catch (error) {
            assert(
                error.message.includes('Only admin can perform this action'),
                'Expected admin restriction error',
            );
        }
    });

    it('should not add an existing user', async () => {
        try {
            await userManagement.addUser(user1, 'User Dup', 1, { from: deployer });
            assert.fail('Expected error not received');
        } catch (error) {
            assert(
                error.message.includes('User already exists'),
                `Expected 'User already exists' but got '${error.message}'`,
            );
        }
    });

    it('should get all users details', async () => {
        const allUsers = await userManagement.getAllUsers();
        assert(allUsers.length === 2, 'There should be 2 users');
        assert(allUsers[0].name === 'Admin', "First user should be 'Admin'");
        assert(allUsers[1].name === 'Supplier1', "Second user should be 'Supplier1'");
    });
});
