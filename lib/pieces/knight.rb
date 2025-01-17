require_relative 'piece'

# Knight
class Knight < Piece
  include Gallop
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2658" : "\u265E"
  end

  def moves(row, col)
    travails(row, col)
  end
end
