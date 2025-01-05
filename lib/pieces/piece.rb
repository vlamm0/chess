# piece
class Piece
  attr_accessor :dir, :color, :moved

  def initialize(col = 1)
    @color = col == 1 ? 'white' : 'black'
    @moved = false
    @dir = @color == 'white' ? 1 : -1
  end
end
