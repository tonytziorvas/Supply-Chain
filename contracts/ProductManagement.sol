// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './UserManagement.sol';

contract ProductManagement is UserManagement {
    struct Product {
        uint256 id;
        string name;
        uint256 quantity;
    }

    mapping(uint256 => Product) public products;
    uint256 public productCount = 0;

    // Events for product management
    event ProductAdded(uint256 indexed productId, string name, uint256 quantity);
    event ProductUpdated(uint256 indexed productId, string name, uint256 quantity);

    // Add Product
    function addProduct(
        uint256 _id,
        string memory _name,
        uint256 _quantity
    ) public onlySupplier {
        products[_id] = Product(_id, _name, _quantity);
        productCount++;
        emit ProductAdded(_id, _name, _quantity);
    }

    // Update Product
    function updateProduct(
        uint256 _id,
        string memory _name,
        uint256 _quantity
    ) public onlySupplier {
        require(products[_id].quantity > 0, 'Product does not exist');
        products[_id].name = _name;
        products[_id].quantity = _quantity;
        emit ProductUpdated(_id, _name, _quantity);
    }

    // Get Product
    function getProduct(
        uint256 _id
    ) public view onlySupplier returns (string memory, uint256) {
        require(products[_id].quantity > 0, 'Product does not exist');
        Product storage product = products[_id];
        return (product.name, product.quantity);
    }
}
