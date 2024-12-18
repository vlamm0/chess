# Pawn
class Pawn
  attr_accessor :sym

  def initialize(col = 1)
    @sym = col == 1 ? "\u2659" : "\u265F"
    # maybe put each pieces pos here?
  end

  def move
    [1, 0]
  end
end
