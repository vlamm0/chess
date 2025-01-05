require_relative 'piece'

# Pawn
class Pawn < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(col = 1)
    super
    @sym = col == 1 ? "\u2659" : "\u265F"
    # maybe put each pieces pos here?
  end

  def move
    [1, 0]
  end
end
