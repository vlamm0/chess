require_relative 'piece'

# Queen
class Queen < Piece
  include Directions
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2654" : "\u265A"
  end

  def moves
    [hor, vert, diag1, diag2].flatten
  end
end
