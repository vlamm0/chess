require_relative 'piece'

# King
class King < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2655" : "\u265B"
  end
end
