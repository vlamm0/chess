require_relative 'piece'

# Bishop
class Bishop < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(col = 1)
    super
    @sym = color == 'white' ? "\u2657" : "\u265D"
  end
end
