require 'rspec'
require_relative '../lib/slot'
require_relative '../lib/vending_machine'

describe VendingMachine do

  describe 'add_slot' do

    it 'should add a slot' do
      machine = VendingMachine.new(1, 'Flemingsbergs Station')
      slot = Slot.new('Testvara', 10, 5, 1)
      expect( machine.slots.empty? ).to be true

      machine.add_slot(slot)
      expect( machine.slots.count ).to eq 1

      machine.add_slot(slot)
      expect( machine.slots.count ).to eq 2
    end
  end

  describe 'print_inventory' do

    before do
      $stdout = StringIO.new
    end

    after(:all) do
      $stdout = STDOUT
    end

    it 'should print a formatted list of all slots' do
      machine = VendingMachine.new(1, 'Flemingsbergs Station')
      slot1 = Slot.new('Testvara 1', 10, 5, 1)
      slot2 = Slot.new('Testvara 2', 15, 10, 1)
      slot3 = Slot.new('Testvara 3', 20, 15, 1)
      machine.add_slot(slot1)
      machine.add_slot(slot2)
      machine.add_slot(slot3)

      machine.print_inventory
      expect( $stdout.string).to match "1: Testvara 1 - 10kr (5 st)\n2: Testvara 2 - 15kr (10 st)\n3: Testvara 3 - 20kr (15 st)\n"
    end
  end


  describe 'buy' do

    before do
      $stdout = StringIO.new
    end

    after(:all) do
      $stdout = STDOUT
    end

    it 'should return the money and print "Sorry, <item> is out of stock" if the selected item is out of stock' do
      machine = VendingMachine.new(1, 'Flemingsbergs Station')
      slot1 = Slot.new('Testvara 1', 10, 0, 1)
      machine.add_slot(slot1)

      machine.buy(slot_number: 1, amount_paid: 10)
      expect( $stdout.string ).to match "Sorry, Testvara 1 is out of stock\nHere is your 10kr back\n"
    end

    it 'should return the money and print "Sorry, you need <difference>kr more to buy <item>"' do
      machine = VendingMachine.new(1, 'Flemingsbergs Station')
      slot1 = Slot.new('Testvara 1', 10, 4, 1)
      machine.add_slot(slot1)

      expect( machine.change ).to eq 120
      machine.buy(slot_number: 1, amount_paid: 6)
      expect( $stdout.string ).to match "Sorry, you need 4kr more to buy Testvara 1\nHere is your 6kr back\n"
      expect( machine.change ).to eq 120
    end

    it 'should return the money and print "Sorry, slot <slot> does not exist" if the selected slot does not exist' do
      machine = VendingMachine.new(1, 'Flemingsbergs Station')
      slot1 = Slot.new('Testvara 1', 10, 0, 1)
      machine.add_slot(slot1)

      machine.buy(slot_number: 0, amount_paid: 10)
      expect( $stdout.string ).to match "Sorry, slot 0 does not exist\nHere is your 10kr back\n"

      machine.buy(slot_number: -42, amount_paid: 10)
      expect( $stdout.string ).to match "Sorry, slot -42 does not exist\nHere is your 10kr back\n"

      machine.buy(slot_number: 2, amount_paid: 10)
      expect( $stdout.string ).to match "Sorry, slot 2 does not exist\nHere is your 10kr back\n"
    end

    it 'should return any change and print "Here is your <item>"' do
      machine = VendingMachine.new(1, 'Flemingsbergs Station')
      slot1 = Slot.new('Testvara 1', 10, 3, 1)
      machine.add_slot(slot1)

      expect( machine.change ).to eq 120
      machine.buy(slot_number: 1, amount_paid: 10)
      expect( $stdout.string ).to match "Here is your Testvara 1"
      expect( machine.change ).to eq 130
      machine.buy(slot_number: 1, amount_paid: 12)
      expect( $stdout.string ).to match "Here is your Testvara 1\nHere is your 2kr back\n"
      expect( machine.change ).to eq 140
    end
  end
end