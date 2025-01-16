require_relative 'piece'

# Pawn
class Pawn < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2659" : "\u265F"
    @dir = color == 'white' ? -1 : 1
  end

  def moves(row, col, blocked)
    possible_moves = []
    possible_moves.append([row + @dir, col]) unless blocked[0]
    possible_moves.append([row + (@dir * 2), col]) unless moved || blocked[0] || blocked[1]
    possible_moves # .filter { |move| on_board?(move) }
  end

  def attacks(row, col)
    [[row + @dir, col - 1], [row + @dir, col + 1]]
  end

  def blocked?
    proc do |ahead1, ahead2|
      [ahead1 != '', ahead2 != '']
    end
  end
end

# I believe this game method is unnecessary after refactoring, keeping here for safety
# def handle_pawn(selection, row, col)
#   empty = data[row][col] == ''
#   return YELLOW if selection[1] == col

#   empty ? bg_tile(row, col) : RED
# end
# called in hl_tile method instead of return YELLOW
# # return handle_pawn(selection, row, col) if selected_piece.is_a?(Pawn)
