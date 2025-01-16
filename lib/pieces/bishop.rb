require_relative 'piece'

# Bishop
class Bishop < Piece
  include Directions
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2657" : "\u265D"
  end

  def moves
    [diag1, diag2].flatten
  end
end
