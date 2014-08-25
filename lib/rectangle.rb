class Rectangle

  attr_reader :width, :heigth

  def initialize(length, tallness)
    @width = length
    @height = tallness
  end

  def width=(new_width)
    @width = new_width if new_width > 0
  end

  def area
    return @width * @height
  end

end

class Square < Rectangle

  def initialize(side)
    @width = side
    @height = side
  end

  def width=(new_width)
    @width = new_width
    @height = new_width
  end

end











