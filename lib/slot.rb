class Slot

  attr_reader :name, :stock_level, :price

  def initialize(name, price, stock_level, refill_warning_level)
    @name = name
    @price = price
    @stock_level = stock_level
    @refill_warning_level = refill_warning_level
  end

  def out_of_stock?
    self.stock_level == 0
  end

  def buy(amount_paid)
    raise PaidTooLittleError.new("Amount paid must not be less than the item's price", @price - amount_paid, ) if amount_paid < @price
    decrease_stock
  end

  def to_s
    "#{self.name} - #{@price}kr (#{self.stock_level} st)"
  end

  private
  def decrease_stock
    raise OutOfStockError, 'Out of stock' if self.out_of_stock?
    @stock_level -= 1
  end

end

class OutOfStockError < StandardError; end
class PaidTooLittleError < StandardError

  attr_reader :amount

  def initialize(message, amount)
    super(message)
    @amount = amount
  end

end