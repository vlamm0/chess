# Rook
class Rook
  attr_accessor :sym

  def initialize(col = 1)
    @sym = col == 1 ? "\u2656" : "\u265C"
  end
end
