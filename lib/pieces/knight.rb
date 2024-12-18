# Knight

# Rook
class Knight
  attr_accessor :sym

  def initialize(col = 1)
    @sym = col == 1 ? "\u2658" : "\u265E"
  end
end
