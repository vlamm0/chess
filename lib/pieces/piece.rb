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

  def directions
    [hor, vert, diag1, diag2].flatten!
  end

  def sliding?(proc)
    pp proc
    pp directions
    directions.any? { |dir| dir == proc }
  end
end

# moveset for knight
module Gallop
  MOVES = [[1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]].freeze
  def travails
    MOVES.map { |move| proc { |pos| [move[0] + pos[0], move[1] + pos[1]] } }
  end
end

# moveset for pawn (and is used for King check!)
module PawnAtks
  def left_atk
    proc { |pos| atks(pos[0], pos[1])[0] }
  end

  def right_atk
    proc { |pos| atks(pos[0], pos[1])[1] }
  end

  # unlessed !blocked
  def atks(row, col)
    [[@dir + row, col - 1], [@dir + row, col + 1]]
  end
end
