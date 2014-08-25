class VendingMachine

  attr_reader :slots, :change

  def initialize(id, position)
    @id = id
    @position = position
    @change = 120
    @slots = []
  end

  def add_slot(item)
    @slots << item
  end

  def add_amount_paid_to_change(amount_paid)
    @change += amount_paid
  end

  # Returns the item at the selected slot
  def slot(number)
    raise NoSuchSlotError, 'The selected slot does not exist' if number <= 0 || number > @slots.count
    @slots[number - 1]
  end

  def calculate_and_return_change_for(item, amount_paid)
    if item && !item.out_of_stock?
      change = (amount_paid - item.price)
    else
      change = amount_paid
    end
    @change -= change
    return change
  end

  def print_inventory
    @slots.each_with_index do |item, i|
      puts "#{i + 1}: #{item}"
    end
  end

  def buy(slot_number:, amount_paid:)
    begin
      item = slot(slot_number)
      item.buy(amount_paid)
      add_amount_paid_to_change(amount_paid)
      puts "Here is your #{item.name}"
      change = calculate_and_return_change_for(item, amount_paid)
    rescue OutOfStockError => e
      puts "Sorry, #{item.name} is out of stock"
    rescue NoSuchSlotError => e
      puts "Sorry, slot #{slot_number} does not exist"
    rescue PaidTooLittleError => e
      puts "Sorry, you need #{ e.amount }kr more to buy #{item.name}"

    # Always calculate the change, even if an exception has been raised
    ensure
      # If we already calculated change, set change to that.
      # If not, we have run into an exception, change has not been set, we and need to set change to amount_paid
      change = change ? change : amount_paid
      puts "Here is your #{change}kr back" if change > 0
    end
  end
end

class NoSuchSlotError < StandardError; end