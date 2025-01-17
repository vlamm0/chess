# requires files
folder = '/home/zach/ODIN/chess/lib/pieces'
Dir.entries(folder).each { |file| require_relative "./pieces/#{file}" unless file[0] == '.' }
require_relative 'data'

# Chess
class Chess
  ALPH = %w[A B C D E F G H].freeze
  GREEN = "\e[48;5;10m".freeze
  YELLOW = "\e[48;5;11m".freeze
  RED = "\e[48;5;9m".freeze
  WHITE = "\e[48;5;255m".freeze
  GRAY = "\e[48;5;244m".freeze
  attr_accessor :data

  # uses the required data file for state, start or saved (to be implemented!)
  def initialize
    @data = MyData.board
  end

  # draws the entire board, including the row/col headers
  def chessboard(highlights = nil, selection = nil)
    puts "\n   #{ALPH.join('  ')}"
    8.times do |row|
      print "#{row} "
      8.times { |col| print draw_tile(row, col, highlights, selection) }
      puts
    end
  end

  # draws each chess tile using the index in the 2d arr of chess data
  def draw_tile(row, col, highlights, selection, piece = data[row][col])
    # colors the selected piece green
    return "#{GREEN} \e[38;5;0m#{piece.sym} \e[0m" if selection == [row, col]

    # Determine what exists in the tile: piece or empty
    tile = piece == '' ? "\s\s\s" : " \e[38;5;0m#{piece.sym} \e[0m"

    # Determine RED, YELLOW, or standard
    color = highlights&.include?([row, col]) ? hl_tile(row, col) : bg_tile(row, col)
    "#{color}#{tile}\e[0m"
  end

  # needs to handle pawn functioning
  def hl_tile(row, col)
    data[row][col] == '' ? YELLOW : RED
  end

  def bg_tile(row, col)
    (row + col).even? ? WHITE : GRAY
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
    puts "\n\n#{piece.class}"
    possible_moves =
      piece.is_a?(Pawn) ? handle_pawn(row, col, piece) : handle_sliders(row, col, piece)
    # possible_moves = handle_pieces(row, col, piece)
    # pp possible_moves
    possible_moves.each { |move| print "#{ALPH[move[1]]}#{move[0]} " }
    puts
    chessboard(possible_moves, [row, col])
  end

  def handle_pieces(row, col, piece)
    piece.moves.map { |proc| dfs([row, col], piece, proc) }.flatten(1)
  end

  def handle_pawn(row, col, piece)
    forward = row + piece.dir
    blocks = piece.blocked?.call(data[forward][col], data[forward + piece.dir][col])
    piece.moves(row, col, blocks) + pawn_attacks(forward, col)
  end

  def pawn_attacks(forward, col, atks = [])
    atks << [forward, col - 1] if data[forward][col - 1] != ''
    atks << [forward, col + 1] if data[forward][col + 1] != ''
    atks
  end

  def handle_sliders(row, col, piece)
    piece.moves.map { |proc| dfs([row, col], piece, proc) }.flatten(1)
  end

  def handle_knight(row, col, piece)
    piece.moves(row, col).filter { |move| on_board?(move) }
  end

  def alph_to_num(letter)
    ALPH.index(letter.upcase!)
  end

  def on_board?(move)
    move[0].between?(0, 7) && move[1].between?(0, 7)
  end

  # finds available moves for sliding pieces
  # color is not needed and piece could be easier
  def dfs(pos, piece, proc, acc = [])
    # base
    pos = proc.call(pos) # next proc
    return acc unless on_board?(pos)

    curr = data[pos[0]][pos[1]] # need variable for abc
    return acc if same_team?(piece.color, curr)

    acc.append(pos) # only sends back next pos when onboard and not on the same team
    return acc if curr != '' || piece.is_a?(Gallop)

    # recurse
    # pp 'made it?'
    dfs(pos, piece, proc, acc)
  end

  def same_team?(color, piece)
    return false if piece == ''

    color == piece.color
  end

  # ***dev methods***

  # helper method to change data
  def change_data(piece_x, piece_y, move_x = nil, move_y = nil)
    piece = [piece_x, piece_y]
    y = piece.find { |axis| axis.is_a?(Integer) }
    x = alph_to_num(piece.find { |axis| axis.is_a?(String) })
    move_x.nil? && move_y.nil? ? data[y][x] = '' : move([y, x], [move_y, move_x])
  end
end

game = Chess.new
game.chessboard
# game.move([6, 0], [2, 0])
game.change_data('a', 1)
game.change_data('h', 0)
game.change_data('e', 6)
game.change_data('g', 6)
# game.select(0, 0)

# bishop test
game.move([7, game.alph_to_num('f')], [5, 5])
game.select(5, 5)

# rook test
game.move([0, game.alph_to_num('a')], [5, 5])
game.select(5, 5)

# queen test
game.move([0, game.alph_to_num('e')], [5, 5])
game.select(5, 5)

# pawn test
game.move([6, game.alph_to_num('a')], [2, 1])
# game.move([1, game.alph_to_num('c')], [2, 2])
game.move([6, game.alph_to_num('c')], [2, 0])
game.select(1, 1)

# knight test
game.select(7, 6)
# game.data[7][6].moves(7, 6)

# king test
game.move([5, game.alph_to_num('f')], [6, game.alph_to_num('e')])
game.select(7, 4)
