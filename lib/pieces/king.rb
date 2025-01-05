require_relative 'piece'

# King
class King < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(col = 1)
    super
    @sym = col == 1 ? "\u2655" : "\u265B"
  end
end
