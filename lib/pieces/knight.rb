require_relative 'piece'

# Knight
class Knight < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2658" : "\u265E"
  end
end
