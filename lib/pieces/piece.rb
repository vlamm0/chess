# piece
class Piece
  attr_accessor :dir, :color, :moved

  def initialize(color)
    @color = color
    @moved = false
  end

  def on_board?(move)
    move[0].between?(0, 7) && move[1].between?(0, 7)
  end
end
