require_relative 'piece'

# Queen
class Queen < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(col = 1)
    super
    @sym = col == 1 ? "\u2654" : "\u265A"
  end
end
