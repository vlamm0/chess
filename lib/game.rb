# requires files
folder = '/home/zach/ODIN/chess/lib/pieces'
Dir.entries(folder).each { |file| require_relative "./pieces/#{file}" unless file[0] == '.' }
require_relative 'data'

# Chess
class Chess
  attr_accessor :data

  # uses the required data file for state, start or saved (to be implemented!)
  def initialize
    @data = MyData.board
  end

  # draws a chess tile using the piece data
  def draw_tile(row, col, highlights, selection, piece = data[row][col])
    # Determine the tile color and symbol
    tile = piece == '' ? '   ' : " \e[38;5;0m#{piece.sym} \e[0m"

    # colors the selected piece green
    return "\e[48;5;10m#{tile}" if selection == [row, col]

    # highlights valid moves yellow and valid captures red
    # move_color will have to be refactored into a function to handle pawn functioning as well as same-team blockage
    move_color = piece == '' ? 11 : 9
    return "\e[48;5;#{move_color}m#{tile}" if highlights&.include?([row, col])

    # If not selected or highlighted, alternate between light and dark squares
    bg_color = (row + col).even? ? 255 : 244
    "\e[48;5;#{bg_color}m#{tile}\e[0m"
  end

  # draws the entire board, including the row/col headers
  def chessboard(highlights = nil, selection = nil)
    alph = %w[A B C D E F G H]
    puts "   #{alph.join('  ')}"
    8.times do |row|
      print "#{row} "
      8.times { |col| print draw_tile(row, col, highlights, selection) }
      puts
    end
  end

  # moves piece
  def move(curr, to)
    data[to[0]][to[1]] = data[curr[0]][curr[1]]
    data[curr[0]][curr[1]] = ''
    # may have to change this piece's @moved to true
  end

  # shows available moves for selected piece
  def select(row, col, piece = data[row][col])
    possible_moves = []
    piece.moves.each do |move|
      possible_moves.append([row + move[0], col + move[1]])
    end
    # need to ensure the moves are valid

    chessboard(possible_moves, [row, col])
  end
end

game = Chess.new
game.chessboard
game.move([6, 0], [3, 0])
game.select(1, 0)
