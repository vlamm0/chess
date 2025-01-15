require_relative 'piece'

# Pawn
class Pawn < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2659" : "\u265F"
    @dir = color == 'white' ? -1 : 1
  end

  def moves(row, col)
    possible_moves = [[row + @dir, col + 0]]
    possible_moves.append([row + (@dir * 2), col + 0]) unless moved
    possible_moves.filter { |move| on_board?(move) }
  end

  def attacks(row, col)
    [[row + @dir, col - 1], [row + @dir, col + 1]].filter { |move| on_board?(move) }
  end
end
