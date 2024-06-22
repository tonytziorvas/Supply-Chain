// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './UserManagement.sol';
import './ProductManagement.sol';

contract ShippingManagement is UserManagement {
    struct Shipping {
        uint256 id;
        uint256[] productIds;
        string origin;
        string destination;
        uint256 departureDate;
        uint256 expectedArrivalDate;
        uint8 position; // Position as an integer for hierarchy
    }

    mapping(uint256 => Shipping) public shipments;
    uint256 public shipmentCount = 0;

    // Position constants
    uint8 constant SUPPLIER_POSITION = 1;
    uint8 constant TRANSPORT_POSITION = 2;
    uint8 constant MANUFACTURER_POSITION = 3;
    uint8 constant LOGISTIC_WAREHOUSE_POSITION = 4;
    uint8 constant DISTRIBUTOR_POSITION = 5;
    uint8 constant PHARMACY_POSITION = 6;

    // Events for shipping management
    event ShipmentAdded(
        uint256 indexed shipmentId,
        uint256[] productIds,
        string origin,
        string destination,
        uint256 departureDate,
        uint256 expectedArrivalDate,
        uint8 position
    );
    event ShipmentUpdated(
        uint256 indexed shipmentId,
        uint256[] productIds,
        string origin,
        string destination,
        uint256 departureDate,
        uint256 expectedArrivalDate,
        uint8 position
    );
    event ShipmentDeleted(uint256 indexed shipmentId);

    // Add Shipment
    function addShipment(
        uint256 _id,
        uint256[] memory _productIds,
        string memory _origin,
        string memory _destination,
        uint256 _departureDate,
        uint256 _expectedArrivalDate,
        uint8 _position
    ) public onlySupplier {
        shipments[_id] = Shipping(
            _id,
            _productIds,
            _origin,
            _destination,
            _departureDate,
            _expectedArrivalDate,
            _position
        );
        shipmentCount++;
        emit ShipmentAdded(
            _id,
            _productIds,
            _origin,
            _destination,
            _departureDate,
            _expectedArrivalDate,
            _position
        );
    }

    // Update Shipment
    function updateShipment(
        uint256 _id,
        uint256[] memory _productIds,
        string memory _origin,
        string memory _destination,
        uint256 _departureDate,
        uint256 _expectedArrivalDate,
        uint8 _position
    ) public onlyLogisticOrAbove {
        require(shipments[_id].departureDate > 0, 'Shipment does not exist');
        shipments[_id].productIds = _productIds;
        shipments[_id].origin = _origin;
        shipments[_id].destination = _destination;
        shipments[_id].departureDate = _departureDate;
        shipments[_id].expectedArrivalDate = _expectedArrivalDate;
        shipments[_id].position = _position;
        emit ShipmentUpdated(
            _id,
            _productIds,
            _origin,
            _destination,
            _departureDate,
            _expectedArrivalDate,
            _position
        );
    }

    // Get Shipment
    function getShipment(
        uint256 _id
    )
        public
        view
        returns (
            uint256,
            uint256[] memory,
            string memory,
            string memory,
            uint256,
            uint256,
            uint8
        )
    {
        require(
            shipments[_id].departureDate > 0 && users[msg.sender].role > 0,
            'Shipment does not exist'
        );
        Shipping storage shipment = shipments[_id];

        // Access restriction based on user roles and shipment position
        if (users[msg.sender].role == SUPPLIER) {
            require(
                shipment.position <= MANUFACTURER_POSITION,
                'Access denied: Supplier can only view status until Manufacturer stage'
            );
        } else if (users[msg.sender].role == LOGISTIC_EMPLOYEE) {
            require(
                shipment.position <= LOGISTIC_WAREHOUSE_POSITION,
                'Access denied: Logistic Employee can only view status until Logistic Warehouse stage'
            );
        } else {}

        return (
            shipment.id,
            shipment.productIds,
            shipment.origin,
            shipment.destination,
            shipment.departureDate,
            shipment.expectedArrivalDate,
            shipment.position
        );
    }

    // Delete Shipment
    function deleteShipment(uint256 _id) public onlyInspector {
        require(shipments[_id].departureDate > 0, 'Shipment does not exist');
        delete shipments[_id];
        emit ShipmentDeleted(_id);
    }

    // Count Shipments
    function getShipmentCount() public view returns (uint256) {
        return shipmentCount;
    }
}
