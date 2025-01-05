require_relative 'piece'

# Knight
class Knight < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(col = 1)
    super
    @sym = col == 1 ? "\u2658" : "\u265E"
  end
end
