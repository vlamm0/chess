require_relative 'piece'

# Pawn
class Pawn < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2659" : "\u265F"
    @dir = color == 'white' ? -1 : 1
  end

  def moves(bools, available_moves = [])
    # pp bools
    procs = [spacex1, spacex2, left_atk, right_atk].flatten
    bools.each_with_index do |bool, i|
      available_moves.append(procs[i]) if bool
    end
    available_moves
    # .reject { |proc, i| i == bools[i] }
  end

  #
  def spacex1
    proc { |pos| [@dir + pos[0], pos[1]] }
  end

  def spacex2
    proc { |pos|
      # have to call prev
      moved ? nil : [@dir + @dir + pos[0], pos[1]]
    }
  end

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

  def blocked?(bools)
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
