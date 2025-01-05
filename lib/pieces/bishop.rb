require_relative 'piece'

# Bishop
class Bishop < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2657" : "\u265D"
  end
end
