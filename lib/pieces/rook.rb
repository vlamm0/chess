require_relative 'piece'

# Rook
class Rook < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2656" : "\u265C"
  end
end
