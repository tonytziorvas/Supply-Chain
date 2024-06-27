const UserManagement = artifacts.require('UserManagement');
const ProductManagement = artifacts.require('ProductManagement');
const ShippingManagement = artifacts.require('ShippingManagement');
const SupplyChain = artifacts.require('SupplyChain');

module.exports = async function (deployer, network, accounts) {
    // Deploy UserManagement
    await deployer.deploy(UserManagement, 'Admin');
    const userManagement = await UserManagement.deployed();

    // Deploy ProductManagement
    await deployer.deploy(ProductManagement);
    const productManagement = await ProductManagement.deployed();

    // Deploy ShippingManagement
    await deployer.deploy(ShippingManagement);
    const shippingManagement = await ShippingManagement.deployed();

    // Deploy SupplyChain with the addresses of the above contracts
    await deployer.deploy(
        SupplyChain,
        userManagement.address,
        productManagement.address,
        shippingManagement.address,
    );
    const supplyChain = await SupplyChain.deployed();

    console.log('UserManagement deployed at:', userManagement.address);
    console.log('ProductManagement deployed at:', productManagement.address);
    console.log('ShippingManagement deployed at:', shippingManagement.address);
    console.log('SupplyChain deployed at:', supplyChain.address);
};
