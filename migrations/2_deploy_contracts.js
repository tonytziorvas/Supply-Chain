const ProductManagement = artifacts.require("ProductManagement");
const ShippingManagement = artifacts.require("ShippingManagement");
const UserManagement = artifacts.require("UserManagement");

module.exports = function(deployer) {
  deployer.deploy(ProductManagement);
  deployer.deploy(ShippingManagement);
  deployer.deploy(UserManagement);
};
