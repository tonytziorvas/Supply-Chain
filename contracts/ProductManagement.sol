// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProductManagement {
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
    event ProductRemoved(uint256 indexed productId, string name);

    function addProduct(string memory _name, uint256 _quantity) public {
        productCount++;
        products[productCount] = Product({id: productCount, name: _name, quantity: _quantity});

        emit ProductAdded(productCount, _name, _quantity);
    }

    function updateProduct(uint256 _productId, string memory _name, uint256 _quantity) public {
        require(_productId > 0 && _productId <= productCount, 'Invalid product ID');
        Product storage product = products[_productId];
        product.name = _name;
        product.quantity = _quantity;

        emit ProductUpdated(_productId, _name, _quantity);
    }

    // Remove an existing product
    function removeProduct(uint256 _productId) public {
        require(_productId > 0 && _productId <= productCount, 'Invalid product ID');

        // Remove the product by moving the last product into the place of the one to delete
        Product storage lastProduct = products[productCount];
        Product storage productToRemove = products[_productId];
        string memory _name = productToRemove.name;

        productToRemove.id = lastProduct.id;
        productToRemove.name = lastProduct.name;
        productToRemove.quantity = lastProduct.quantity;

        delete products[productCount];
        productCount--;

        emit ProductRemoved(_productId, _name);
    }
}
