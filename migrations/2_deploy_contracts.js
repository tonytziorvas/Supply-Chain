const UserManagement = artifacts.require('UserManagement');
const ProductManagement = artifacts.require('ProductManagement');
const ShippingManagement = artifacts.require('ShippingManagement');

module.exports = function (deployer) {
    deployer.deploy(UserManagement, 'Admin');
    deployer.deploy(ProductManagement);
    deployer.deploy(ShippingManagement);
};
