# piece
class Piece
  attr_accessor :dir, :color, :moved

  def initialize(color)
    @color = color
    @dir = color == 'white' ? -1 : 1
    @moved = false
  end
end
