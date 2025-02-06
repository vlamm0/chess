# requires files
folder = '/home/zach/ODIN/chess/lib/pieces'
Dir.entries(folder).each { |file| require_relative "./pieces/#{file}" unless file[0] == '.' }
require_relative 'data'

# Chess
class Chess
  # include Directions
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
    tile = piece.nil? ? "\s\s\s" : " \e[38;5;0m#{piece.sym} \e[0m"

    # Determine RED, YELLOW, or standard
    color = highlights&.include?([row, col]) ? hl_tile(row, col) : bg_tile(row, col)
    "#{color}#{tile}\e[0m"
  end

  # needs to handle pawn functioning
  def hl_tile(row, col)
    data[row][col].nil? ? YELLOW : RED
  end

  def bg_tile(row, col)
    (row + col).even? ? WHITE : GRAY
  end

  # moves piece
  def move(curr, to)
    # the parameters for move will take player input, so these assignments will be unnecessary
    # curry, currx = curr
    # toy, tox = to
    # swap
    data[to[0]][to[1]] = get_piece(curr) # data[curry][currx]
    data[curr[0]][curr[1]] = nil
    get_piece(to).moved = true
  end

  # shows available moves for selected piece
  def select(row, col, piece = data[row][col])
    puts "\n\n#{piece.class}"
    possible_moves = get_moves(row, col, piece) # handle_pieces(row, col, piece)
    possible_moves.each { |move| print "#{ALPH[move[1]]}#{move[0]} " }
    puts
    # pp possible_moves
    chessboard(possible_moves, [row, col])
  end

  # I can get moves here and pass it to handle_pieces. This way I can utilize the handle pieces method with the king's check moves but as a slider piece for dfs
  def get_moves(row, col, piece)
    moves = piece.is_a?(Pawn) ? piece.moves(pawn_blocks(row, col, piece)) : piece.moves
    handle_pieces([row, col], piece, moves)
  end

  def handle_pieces(pos, piece, moves)
    moves.map { |proc| dfs(pos, piece, proc) }.flatten(1)
  end

  def pawn_blocks(row, col, piece, forward = row + piece.dir)
    space = data[forward][col].nil?
    blocks = [space, space && data[forward + piece.dir][col].nil?]
    blocks + pawn_attacks(row, col, piece)
  end

  def pawn_attacks(row, col, piece)
    piece.atks(row, col).map { |atk| !data[atk[0]][atk[1]].nil? }
  end

  # translate alph to num and [] to piece
  def translate(var)
    ALPH.index(var.upcase!)
  end

  def get_piece(pos)
    data[pos[0]][pos[1]]
  end

  def on_board?(move)
    return false if move.nil?

    move[0].between?(0, 7) && move[1].between?(0, 7)
  end

  # finds available moves for piece
  def dfs(pos, piece, proc, acc = [])
    # base
    pos = proc.call(pos) # next proc
    return acc unless on_board?(pos)

    curr = data[pos[0]][pos[1]] # need variable for abc
    return acc if same_team?(piece.color, curr)

    acc.append(pos) # only sends back next pos when on board and not on the same team
    # return if piece is a king, pawn, or knight
    return acc if !curr.nil? ||  piece.is_a?(King) || !piece.is_a?(Directions)

    # recurse
    dfs(pos, piece, proc, acc)
  end

  def same_team?(color, piece)
    return false if piece.nil?

    color == piece.color
  end

  # missing knight
  def check?(pos)
    piece = get_piece(pos)
    color = piece.color
    # atk_vector = get_moves(pos[0], pos[1], Queen.new(color), piece.moves) + piece.atks(pos[0], pos[1])
    atk_vector = handle_pieces(pos, Queen.new(color), piece.moves) + piece.attacks(pos[0], pos[1])
    # pp atk_vector
    atks_on_king?(atk_vector, color)
  end

  # need to test with multiple attackers
  def atks_on_king?(atk_vector, color)
    attacks = atk_vector.each_with_object([]) do |atk, accum|
      # Reject logic - skip items where the condition is true
      next atk if get_piece(atk).nil? || same_team?(color, get_piece(atk))

      # Handle pieces and accumulate the result
      accum.concat(get_moves(atk[0], atk[1], get_piece(atk)))
      # accum.concat(handle_pieces(atk, get_piece(atk), get_piece(atk).moves))
    end
    !attacks.filter { |pos| get_piece(pos).is_a?(King) }.empty?
  end

  # ***dev methods***

  # helper method to change data
  def change_data(piece_x, piece_y, move_x = nil, move_y = nil)
    piece = [piece_x, piece_y]
    y = piece.find { |axis| axis.is_a?(Integer) }
    x = translate(piece.find { |axis| axis.is_a?(String) })
    move_x.nil? && move_y.nil? ? data[y][x] = nil : move([y, x], [move_y, move_x])
  end
end

game = Chess.new
game.chessboard
game.change_data('a', 1)
game.change_data('h', 0)
game.change_data('e', 6)
game.change_data('g', 6)

# bishop test
game.move([7, game.translate('f')], [5, 5])
game.select(5, 5)

# rook test
game.move([0, game.translate('a')], [5, 5])
game.select(5, 5)

# queen test
game.move([0, game.translate('e')], [5, 5])
game.select(5, 5)

# pawn test
game.move([1, game.translate('c')], [2, 2])
game.move([6, game.translate('c')], [2, 0])
game.select(1, 1)

# knight test
game.select(7, 6)
# game.data[7][6].moves(7, 6)

# king test
game.move([5, game.translate('f')], [6, game.translate('e')])
game.select(7, 4)

pp game.check?([7, 4])
puts
puts
game.move([7, game.translate('e')], [3, game.translate('d')])
game.chessboard
pp game.check?([3, 3])
