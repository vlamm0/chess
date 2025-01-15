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

  # draws each chess tile using the index in the 2d arr of chess data
  def draw_tile(row, col, highlights, selection, piece = data[row][col])
    # Determine what exists in the tile: piece or empty
    tile = piece == '' ? "\s\s\s" : " \e[38;5;0m#{piece.sym} \e[0m"

    # colors the selected piece green, technically this can go first as it will never be blank
    return "\e[48;5;10m#{tile}" if selection == [row, col]

    # highlights valid moves yellow and valid captures red
    if highlights&.include?([row, col])
      highlight_tile(selection, row, col, tile)
    else
      background_tile(row, col, tile)
    end
  end

  # needs to handle pawn functioning
  def highlight_tile(selection, row, col, tile)
    selected_piece = data[selection[0]][selection[1]]
    curr_piece = data[row][col]

    # handle pawn method
    return handle_pawn(selection, row, col, tile) if selected_piece.is_a?(Pawn)

    move_color = curr_piece == '' ? 11 : 9
    "\e[48;5;#{move_color}m#{tile}"
  end

  def background_tile(row, col, tile)
    bg_color = (row + col).even? ? 255 : 244
    "\e[48;5;#{bg_color}m#{tile}\e[0m"
  end

  def handle_pawn(selection, row, col, tile)
    selected_piece = data[selection[0]][selection[1]]
    curr_piece = data[row][col]
    # pawn diagnol attack
    return "\e[48;5;9m#{tile}" if selection[1] != col && curr_piece.color != selected_piece.color

    curr_piece == '' ? "\e[48;5;11m#{tile}" : background_tile(row, col, tile)
  end

  # moves piece
  def move(curr, to)
    # the parameters for move will take player input, so these assignments will be unnecessary
    curry, currx = curr
    toy, tox = to
    # swap
    data[toy][tox] = data[curry][currx]
    data[curry][currx] = ''
    data[toy][tox].moved = true
  end

  # shows available moves for selected piece
  def select(row, col, piece = data[row][col])
    possible_moves = piece.moves(row, col)
    if piece.is_a?(Pawn)
      possible_moves.concat(piece.attacks(row, col).select { |attack| data[attack[0]][attack[1]].is_a?(Piece) })
    end

    chessboard(possible_moves, [row, col])
  end
end

game = Chess.new
game.chessboard
game.move([6, 0], [2, 0])
game.select(1, 1)
