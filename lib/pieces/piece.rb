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

# module for the directions of sliding pieces (bishop, rook, queen)
module Directions
  def vert
    proc_vert = proc { |pos| [pos[0], pos[1] + 1] }
    proc_vert_neg = proc { |pos| [pos[0], pos[1] - 1] }
    [proc_vert, proc_vert_neg]
  end

  def hor
    proc_hor = proc { |pos| [pos[0] + 1, pos[1]] }
    proc_hor_neg = proc { |pos| [pos[0] - 1, pos[1]] }
    [proc_hor, proc_hor_neg]
  end

  def diag1
    proc_diag = proc { |pos| [pos[0] + 1, pos[1] + 1] }
    proc_diag_neg = proc { |pos| [pos[0] + 1, pos[1] - 1] }
    [proc_diag, proc_diag_neg]
  end

  def diag2
    proc_diag = proc { |pos| [pos[0] - 1, pos[1] - 1] }
    proc_diag_neg = proc { |pos| [pos[0] - 1, pos[1] + 1] }
    [proc_diag, proc_diag_neg]
  end
end
