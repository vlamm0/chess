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
  attr_accessor :data, :checks

  # uses the required data file for state, start or saved (to be implemented!)
  def initialize
    @data = MyData.board
    @checks = {}
  end

  # draw the board
  def board(highlights = nil, selection = nil)
    puts "\n\n   #{ALPH.join('  ')}"
    8.times do |row|
      print "#{row} "
      8.times { |col| print draw_tile(row, col, highlights, selection) }
      puts
    end
  end

  def draw_tile(row, col, highlights, selection, piece = data[row][col])
    # colors the selected piece green
    return "#{GREEN} \e[38;5;0m#{piece.sym} \e[0m" if selection == [row, col]

    # Determine what exists in the tile: piece or empty AND background tile color
    tile = piece.nil? ? "\s\s\s" : " \e[38;5;0m#{piece.sym} \e[0m"
    color = highlights&.include?([row, col]) ? hl_tile(row, col) : bg_tile(row, col)
    "#{color}#{tile}\e[0m"
  end

  # highlight possible moves, RED or Yellow
  def hl_tile(row, col)
    data[row][col].nil? ? YELLOW : RED
  end

  # color background tile
  def bg_tile(row, col)
    (row + col).even? ? WHITE : GRAY
  end

  # move piece
  def move(curr, to)
    data[to[0]][to[1]] = get_piece(curr)
    data[curr[0]][curr[1]] = nil
    get_piece(to).moved = true
  end

  # highlight (and return) available moves for selected piece
  def select(pos, piece = data[pos[0]][pos[1]])
    puts "\n\n#{piece.class}"
    possible_moves = get_moves(pos, piece)
    possible_moves.each { |move| print "#{ALPH[move[1]]}#{move[0]} " }
    board(possible_moves, pos)
    possible_moves
  end

  # NOTE: pawns need chess data to determine moveset
  def get_moves(pos, piece)
    moves = piece.is_a?(Pawn) ? piece.moves(pawn_blocks(pos, piece) + pawn_attacks(pos, piece)) : piece.moves
    handle_pieces(pos, piece, moves)
  end

  # NOTE: get moves, modularizing this method allows for testing with seperate pieces/movesets (useful for check(mate))
  def handle_pieces(pos, piece, moves)
    moves.map { |proc| dfs(pos, piece, proc) }.flatten(1)
  end

  def pawn_blocks(pos, piece, col = pos[1], forward = pos[0] + piece.dir)
    space = data[forward][col].nil?
    [space, space && data[forward + piece.dir][col].nil?]
  end

  def pawn_attacks(pos, piece)
    piece.atks(pos).map { |atk| !data[atk[0]][atk[1]].nil? }
  end

  # translate alph to num
  def translate(var)
    ALPH.index(var.upcase)
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

  def check?(pos)
    piece = get_piece(pos)
    color = piece.color
    atk_vector = handle_pieces(pos, Queen.new(color), piece.moves) + piece.attacks(pos[0], pos[1])
    atks_on_king?(atk_vector, color)
  end

  def atks_on_king?(atk_vector, color)
    atk_vector.each do |atk|
      piece = get_piece(atk)
      next atk if piece.nil? || same_team?(color, piece)

      moves = piece.is_a?(Pawn) ? piece.atks(atk) : get_moves(atk, piece)
      next atk if moves.filter { |pos| get_piece(pos).is_a?(King) }.empty?

      checks[atk] = moves
    end
    # tmp display hash
    pp checks
    !checks.empty?
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

# chess = Chess.new
# chess.board
# chess.change_data('a', 1)
# chess.change_data('H', 0)
# chess.change_data('e', 6)
# chess.change_data('g', 6)

# # bishop test
# chess.move([7, chess.translate('f')], [5, 5])
# chess.select([5, 5])

# # rook test
# chess.move([0, chess.translate('A')], [5, 5])
# chess.select([5, 5])

# # queen test
# chess.move([0, chess.translate('e')], [5, 5])
# chess.select([5, 5])

# # pawn test
# chess.move([1, chess.translate('c')], [2, 2])
# chess.move([6, chess.translate('c')], [2, 0])
# chess.select([1, 1])

# # knight test
# chess.select([7, 6])

# # king test
# chess.move([5, chess.translate('f')], [6, chess.translate('e')])
# chess.select([7, 4])
