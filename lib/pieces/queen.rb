# Queen
class Queen
  attr_accessor :sym

  def initialize(col = 1)
    @sym = col == 1 ? "\u2654" : "\u265A"
  end
end
