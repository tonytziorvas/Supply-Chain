// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShippingManagement {
    uint256 constant SUPPLIER = 0;
    uint256 constant TRANSPORT = 1;
    uint256 constant MANUFACTURER = 2;
    uint256 constant LOGISTIC_WAREHOUSE = 3;
    uint256 constant DISTRIBUTOR = 4;
    uint256 constant PHARMACY = 5;

    struct Shipping {
        uint256 id;
        uint256[] productIds;
        string origin;
        string destination;
        uint256 departureDate;
        uint256 expectedArrivalDate;
        uint256 status;
    }

    mapping(uint256 => Shipping) public shipments;
    uint256 public shipmentCount = 0;

    // Events for shipping management
    event ShipmentAdded(
        uint256 indexed shipmentId,
        uint256[] productIds,
        string origin,
        string destination,
        uint256 departureDate,
        uint256 expectedArrivalDate,
        uint256 status
    );

    event ShipmentStatusUpdated(uint256 indexed shipmentId, uint256 status);

    event ShipmentDeleted(uint256 indexed shipmentId);

    // Add a new shipment
    function addShipment(
        uint256[] memory _productIds,
        string memory _origin,
        string memory _destination,
        uint256 _departureDate,
        uint256 _expectedArrivalDate
    ) public {
        shipmentCount++;
        shipments[shipmentCount] = Shipping({
            id: shipmentCount,
            productIds: _productIds,
            origin: _origin,
            destination: _destination,
            departureDate: _departureDate,
            expectedArrivalDate: _expectedArrivalDate,
            status: SUPPLIER
        });
        emit ShipmentAdded(
            shipmentCount,
            _productIds,
            _origin,
            _destination,
            _departureDate,
            _expectedArrivalDate,
            SUPPLIER
        );
    }

    // Update shipment status
    function updateShipmentStatus(uint256 _shipmentId, uint256 _status) public {
        require(_shipmentId > 0 && _shipmentId <= shipmentCount, 'Invalid shipment ID');
        require(_status >= SUPPLIER && _status <= PHARMACY, 'Invalid status value');
        shipments[_shipmentId].status = _status;
        emit ShipmentStatusUpdated(_shipmentId, _status);
    }

    // Delete a shipment
    function deleteShipment(uint256 _shipmentId) public {
        require(_shipmentId > 0 && _shipmentId <= shipmentCount, 'Invalid shipment ID');
        delete shipments[_shipmentId].productIds;
        delete shipments[_shipmentId];
        emit ShipmentDeleted(_shipmentId);
    }

    // Function to get the current status of a shipment
    function getCurrentStatus(uint256 _shipmentId) public view returns (uint256) {
        return shipments[_shipmentId].status;
    }
}
