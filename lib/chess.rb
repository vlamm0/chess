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
    @checks = []
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
  def get_moves(pos, piece = get_piece(pos))
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

    curr = get_piece(pos) # data[pos[0]][pos[1]] # get_piece
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

  def check_for_blocks(pos, color)
    # pp pos
    king = King.new(color)
    # pp "block_vector: #{block_vector}"
    # print "check for blocks on #{pos}: "
    block_vector = handle_pieces(pos, Queen.new(color), king.moves) + king.attacks(pos[0], pos[1])

    block_vector =
      block_vector.filter do |block|
        !get_piece(block).nil? && !same_team?(color, get_piece(block)) && !get_piece(block).is_a?(King) && get_moves(block).any?(pos) # && !get_piece(block).is_a?(King) }
      end
    # .filter { |block| !get_piece(block).is_a?(King) }
    # .filter { |blocker| get_moves(blocker).any?(pos) }
    block_vector.map { |blocker| [blocker, pos] }.uniq

    # block_vector.filter! do |block|
    #   !get_piece(block).nil? && !same_team?(color, get_piece(block)) && !get_piece(block).is_a?(King)
    # end
    # block_vector.filter! { |blocker| get_moves(blocker).any?(pos) }
    # # pp "bl v: #{block_vector}"
    # block_vector.map! { |blocker| [blocker, pos] }
    # # pp "bl v: #{block_vector}"
    # block_vector.uniq

    # check if this filtered block list can attack the said space &&
  end

  # we need to pass in piececolor
  def check?(pos, color)
    # @checks.clear
    piece = get_piece(pos)
    # pp pos
    atk_vector = handle_pieces(pos, Queen.new(color), piece.moves) + piece.attacks(pos[0], pos[1])
    # print 'attackers: '
    attackers = atk_vector.filter { |atk| !get_piece(atk).nil? && !same_team?(color, get_piece(atk)) }

    # pp "#{attackers} attackers" # these are possible attackers, pass this into atks on king method
    atks_on_king?(attackers, pos)
  end

  # make sure this works with multple attackers
  def atks_on_king?(attackers, king)
    @checks.clear
    attackers.each do |atk|
      piece = get_piece(atk)

      moves = piece.is_a?(Pawn) ? piece.moves([false, false, true, true]) : piece.moves # get_moves(atk, piece)

      attack_vector = moves.map { |proc| dfs(atk, piece, proc) }.filter do |stream|
        # pp 'stream/king:'
        # pp stream
        # pp king
        stream.any?(king)
      end.flatten(1)

      @checks.append(attack_vector.append(atk)) unless attack_vector.empty?
    end
    # tmp display hash
    # pp " checks: #{checks}"
    !@checks.empty?
  end

  # ***dev methods***

  # helper method to change data
  # def change_data(piece_x, piece_y, move_x = nil, move_y = nil)
  #   piece = [piece_x, piece_y]
  #   y = piece.find { |axis| axis.is_a?(Integer) }
  #   x = translate(piece.find { |axis| axis.is_a?(String) })
  #   move_x.nil? && move_y.nil? ? data[y][x] = nil : move([y, x], [move_y, move_x])
  # end
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
