require_relative 'piece'

# Queen
class Queen < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2654" : "\u265A"
  end
end
