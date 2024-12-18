# Bishop
class Bishop
  attr_accessor :sym

  def initialize(col = 1)
    @sym = col == 1 ? "\u2657" : "\u265D"
  end
end
