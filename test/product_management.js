// File: test/ProductManagement.test.js

const ProductManagement = artifacts.require('ProductManagement');

contract('ProductManagement', (accounts) => {
    let productManagement;
    const [deployer, user1] = accounts;

    beforeEach(async () => {
        productManagement = await ProductManagement.new();
    });

    it('should add a new product', async () => {
        const productName = 'Product1';
        const productQuantity = 100;

        // Add a new product
        const tx = await productManagement.addProduct(productName, productQuantity, {
            from: deployer,
        });
        const productId = tx.logs[0].args.productId.toNumber();

        // Verify event
        assert.equal(tx.logs.length, 1, 'Should have emitted 1 event');
        assert.equal(tx.logs[0].event, 'ProductAdded', 'Event should be ProductAdded');
        assert.equal(
            tx.logs[0].args.name,
            productName,
            'Event should have correct product name',
        );
        assert.equal(
            tx.logs[0].args.quantity.toNumber(),
            productQuantity,
            'Event should have correct product quantity',
        );

        // Verify product details
        const product = await productManagement.products(productId);
        assert.equal(product.name, productName, 'Product name should match');
        assert.equal(
            product.quantity.toNumber(),
            productQuantity,
            'Product quantity should match',
        );
    });

    it('should update an existing product', async () => {
        const initialProductName = 'InitialProduct';
        const updatedProductName = 'UpdatedProduct';
        const initialProductQuantity = 50;
        const updatedProductQuantity = 75;

        // Add an initial product
        await productManagement.addProduct(initialProductName, initialProductQuantity, {
            from: deployer,
        });
        const productId = 1;

        // Update the product
        const tx = await productManagement.updateProduct(
            productId,
            updatedProductName,
            updatedProductQuantity,
            { from: deployer },
        );

        // Verify event
        assert.equal(tx.logs.length, 1, 'Should have emitted 1 event');
        assert.equal(tx.logs[0].event, 'ProductUpdated', 'Event should be ProductUpdated');
        assert.equal(
            tx.logs[0].args.productId.toNumber(),
            productId,
            'Event should have correct product ID',
        );
        assert.equal(
            tx.logs[0].args.name,
            updatedProductName,
            'Event should have correct  product name',
        );
        assert.equal(
            tx.logs[0].args.quantity.toNumber(),
            updatedProductQuantity,
            'Event should have correct product quantity',
        );

        // Verify updated product details
        const updatedProduct = await productManagement.products(productId);
        assert.equal(
            updatedProduct.name,
            updatedProductName,
            'Product name should be updated',
        );
        assert.equal(
            updatedProduct.quantity.toNumber(),
            updatedProductQuantity,
            'Product quantity should be updated',
        );
    });

    it('should remove a product', async () => {
        const _name = 'Product_2';
        const _quantity = 50;

        await productManagement.addProduct(_name, _quantity, { from: deployer });
        const productId = 1;

        const tx = await productManagement.removeProduct(productId, { from: deployer });
        console.log(tx.logs[0]);
        // Verify event
        assert.equal(tx.logs.length, 1, 'Should have emitted 1 event');
        assert.equal(tx.logs[0].event, 'ProductRemoved', 'Event should be ProductRemoved');
        assert.equal(
            tx.logs[0].args.productId.toNumber(),
            productId,
            'Event should have correct product ID',
        );
        assert.equal(
            tx.logs[0].args.name,
            _name,
            'Event should have correct updated product name',
        );
    });
});
