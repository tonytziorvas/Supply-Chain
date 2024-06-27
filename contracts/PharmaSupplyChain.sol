// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './UserManagement.sol';
import './ProductManagement.sol';
import './ShippingManagement.sol';

contract SupplyChain {
    UserManagement public userManagement;
    ProductManagement public productManagement;
    ShippingManagement public shippingManagement;

    constructor(
        address _userManagement,
        address _productManagement,
        address _shippingManagement
    ) {
        userManagement = UserManagement(_userManagement);
        productManagement = ProductManagement(_productManagement);
        shippingManagement = ShippingManagement(_shippingManagement);

        // Initialize user roles
        userManagement.addUser(0x1234567890123456789012345678901234567890, 'Supplier1', 1);
        userManagement.addUser(0x2345678901234567890123456789012345678901, 'Logistic1', 2);
        userManagement.addUser(0x3456789012345678901234567890123456789012, 'Inspector1', 3);

        // Initialize 10 different products
        for (uint i = 0; i < 10; i++) {
            productManagement.addProduct(
                string(abi.encodePacked('Product', uint2str(i))),
                100 + i // Random quantity
            );
        }

        // Create 2-3 shipments
        uint[] memory productIds1 = new uint[](2);
        productIds1[0] = 1;
        productIds1[1] = 2;
        shippingManagement.addShipment(
            productIds1,
            'Supplier A',
            'Logistic B',
            block.timestamp,
            block.timestamp + 3600
        );

        uint[] memory productIds2 = new uint[](3);
        productIds2[0] = 3;
        productIds2[1] = 4;
        productIds2[2] = 5;
        shippingManagement.addShipment(
            productIds2,
            'Supplier C',
            'Logistic D',
            block.timestamp,
            block.timestamp + 7200
        );

        // Update the shipment status of a random shipment
        shippingManagement.updateShipmentStatus(1, 1); // Update status to Transport
    }

    // Helper function to convert uint to string
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return '0';
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
