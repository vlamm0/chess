require_relative 'piece'

# Pawn
class Pawn < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2659" : "\u265F"
    # maybe put each pieces pos here?
  end

  def move
    [1, 0]
  end
end
