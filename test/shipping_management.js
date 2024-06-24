// File: test/ShippingManagement.test.js

const ShippingManagement = artifacts.require('ShippingManagement');

contract('ShippingManagement', () => {
    let shippingManagement;
    before(async () => {
        shippingManagement = await ShippingManagement.deployed();
    });

    // Add a new shipment
    const productIds = [1, 2, 3];
    const origin = 'Factory';
    const destination = 'Warehouse';
    const departureDate = Math.floor(Date.now() / 1000);
    const expectedArrivalDate = departureDate + 3600;

    it('should add a new shipment', async () => {
        const tx = await shippingManagement.addShipment(
            productIds,
            origin,
            destination,
            departureDate,
            expectedArrivalDate,
        );
        const event = tx.logs.find((log) => log.event === 'ShipmentAdded');
        assert.exists(event, 'Event ShipmentAdded not emitted');

        // Access event parameters
        const shipmentId = event.args.shipmentId.toNumber();
        const emittedProductIds = event.args.productIds.map((id) => id.toNumber());
        const emittedOrigin = event.args.origin;
        const emittedDestination = event.args.destination;

        // Asserting the emitted values
        assert.equal(shipmentId, 1, 'Shipment ID should be 1');
        assert.deepEqual(emittedProductIds, productIds, 'Product IDs should match');
        assert.equal(emittedOrigin, origin, 'Origin should match');
        assert.equal(emittedDestination, destination, 'Destination should match');
    });

    it('should update the status of a shipment', async () => {
        await shippingManagement.updateShipmentStatus(1, 1); // Transport status
        const shipment = await shippingManagement.shipments(1);

        assert.equal(
            shipment.status.toNumber(),
            1,
            'Status should be updated to Transport (1)',
        );
    });

    it('should get the current status of a shipment', async () => {
        const status = await shippingManagement.getCurrentStatus(1);

        assert.equal(status.toNumber(), 1, 'Current status should be Transport (1)');
    });

    it('should delete a shipment', async () => {
        await shippingManagement.deleteShipment(1);
        const shipment = await shippingManagement.shipments(1);

        // Ensure shipment is deleted
        assert.equal(shipment.id.toNumber(), 0, 'Shipment ID should be 0 (deleted)');
        assert.equal(shipment.origin, '', 'Origin should be empty (deleted)');
        assert.equal(shipment.destination, '', 'Destination should be empty (deleted)');
        assert.equal(
            shipment.departureDate.toNumber(),
            0,
            'Departure date should be 0 (deleted)',
        );
        assert.equal(
            shipment.expectedArrivalDate.toNumber(),
            0,
            'Expected arrival date should be 0 (deleted)',
        );

        // Ensure productIds array is empty or does not exist
        if (shipment.productIds) {
            assert.equal(
                shipment.productIds.length,
                0,
                'Product IDs should be empty (deleted)',
            );
        }
    });
});
