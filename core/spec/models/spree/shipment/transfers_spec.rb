require 'spec_helper'

describe Spree::Shipment, type: :model do
  describe '#transfer_to_location' do
    let(:stock_location) { create(:stock_location) }
    it 'transfers unit to a new shipment with given location' do
      order = create(:completed_order_with_totals, line_items_count: 2)
      shipment = order.shipments.first
      variant = order.inventory_units.map(&:variant).first

      aggregate_failures("verifying new shipment attributes") do
        expect do
          shipment.transfer_to_location(variant, 1, stock_location)
        end.to change { Spree::Shipment.count }.by(1)

        new_shipment = order.shipments.last
        expect(new_shipment.number).to_not eq(shipment.number)
        expect(new_shipment.stock_location).to eq(stock_location)
        expect(new_shipment.line_items.count).to eq(1)
        expect(new_shipment.line_items.first.variant).to eq(variant)
      end
    end
  end
end
