require 'rspec'
require_relative '../lib/slot'

describe Slot do

  describe 'buy' do

    it 'should subtract one from the stock_level' do
      slot = Slot.new('Testvara', 10, 20, 5)

      expect( slot.stock_level ).to eq 20

      slot.buy(10)
      expect( slot.stock_level ).to eq 19

      slot.buy(10)
      slot.buy(10)
      expect( slot.stock_level ).to eq 17
    end

    it 'should raise OutOfStockError and not change the count if stock_level is 0' do
      slot = Slot.new('Testvara', 10, 1, 3)

      expect{ slot.buy(10) }.not_to raise_error
      expect( slot.stock_level).to eq 0

      expect{ slot.buy(10) }.to raise_error OutOfStockError, 'Out of stock'
      expect( slot.stock_level).to eq 0
    end

    it 'should raise PaidTooLittleError with the remaining amount, and not change stock_level if amount_paid is too low' do
      slot = Slot.new('Testvara', 10, 5, 3)

      expect( slot.stock_level).to eq 5
      expect{ slot.buy(10) }.not_to raise_error
      expect( slot.stock_level).to eq 4

      expect{ slot.buy(7) }.to raise_error PaidTooLittleError, "Amount paid must not be less than the item's price"
      expect( slot.stock_level).to eq 4
    end

  end

  describe 'printing' do

    it 'should print itself correctly' do
      slot = Slot.new('Testvara', 10, 20, 5)
      expect( slot.to_s ).to match 'Testvara - 10kr (20 st)'
    end

  end
end