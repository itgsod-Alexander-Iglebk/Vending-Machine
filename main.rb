require_relative 'lib/vending_machine'
require_relative 'lib/slot'

flempan = VendingMachine.new(42, "Flemingsbergs Station")
huddinge = VendingMachine.new(43, "Huddinge Centrum")

flempan.add_slot(Slot.new("Coca Cola (50cl)", 20, 25, 5))
flempan.add_slot(Slot.new("Fanta (50cl)", 20, 25, 3))

flempan.print_inventory
flempan.buy(slot_number: 2, amount_paid: 20)