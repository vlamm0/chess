require_relative 'piece'

# King
class King < Piece
  include Directions
  include Gallop
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2655" : "\u265B"
  end

  def moves
    [hor, vert, diag1, diag2].flatten
  end
end
