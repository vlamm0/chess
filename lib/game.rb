# get requirements
require 'yaml'
require_relative './chess'
require_relative './player'

# game
class Game
  attr_accessor :players, :game, :turn, :check

  def initialize
    if File.exist?('save.yml')
      load
    else
      @players = [Player.new, Player.new]
      @game = Chess.new
      @turn = 1
      @blocks = []
    end
  end

  # loop through player turn until ending (not recursive to prevent stack overflow)
  def play
    until checkmate?
      # prevent infinite loop while testing
      break if turn > 100

      game.checks.empty? ? move : defend
      @turn += 1
    end
    puts "\n#{whos_turn.opponent} wins!\n"
  end

  # determines checkmate, and to that end records checks on king/potential blocks
  def checkmate?(king = whos_turn.king)
    return false unless game.check?(king, whos_turn.color)

    existing_checks = Marshal.load(Marshal.dump(game.checks))
    shield?(existing_checks)
    escape?(king)
    game.checks = existing_checks
    @blocks.empty? ? true : false
  end

  # abstracted from Chess method, adding functionality to record a player's king
  def move(get = select)
    curr, to = get
    game.move(curr, to)
    whos_turn.king = to if game.get_piece(to).is_a?(King)
  end

  def defend
    moves = select
    moves = select until @blocks.any?(moves)
    move(moves)
  end

  # get player based on the turn
  def whos_turn
    turn.even? ? players[1] : players[0]
  end

  def escape?(king, route: false)
    possible_moves = game.get_moves(king, game.get_piece(king))
    possible_moves.each do |to|
      var = safe_move(king, to, whos_turn.color)
      route = true unless var.nil?
      @blocks.append(var) unless var.nil?
    end
    route
  end

  def safe_move(piece, to, color, stack = [])
    stack.push(game.get_piece(to))
    move([piece, to])
    check = game.check?(whos_turn.king, color)
    move([to, piece])
    game.data[to[0]][to[1]] = stack.pop
    check ? nil : [piece, to]
  end

  # need to ensure king is safe with move
  def shield?(existing_checks)
    @blocks.clear
    return false if existing_checks.length > 1

    existing_checks[0].each do |atk|
      blocker = game.check_for_blocks(atk, whos_turn.opponent).filter do |block|
        !safe_move(block[0], atk, whos_turn).nil?
      end
      @blocks += blocker
    end
  end

  # select (valid) piece and destination
  def select(player = whos_turn)
    game.board
    piece, destination = standardize(your_piece(player.prompt, player.color))
    return [piece, destination] if game.select(piece).include?(destination)

    puts "\n\n***INVALID MOVE***"
    select
  end

  # output valid coord from user input
  def standardize(pos)
    game.select(pos)
    pos, destination = handle_canceling(pos)
    destination = whos_turn.standardize(destination.split(''))
    destination.nil? || destination.length != 2 ? standardize(pos) : [pos, destination]
  end

  def handle_canceling(piece, player = whos_turn)
    puts 'Where to? (enter x to select a different piece)'
    destination = gets.chomp
    return [piece, destination] if destination.downcase != 'x'

    game.board
    [your_piece(player.prompt, player.color), destination]
  end

  # selects your piece
  def your_piece(pos, color)
    your_piece(whos_turn.prompt(true), color) if pos.nil?
    if game.on_board?(pos) && game.same_team?(color, game.get_piece(pos))
      pos
    else
      your_piece(whos_turn.prompt(true), color)
    end
  end

  def save_game
    File.open('save.yml', 'w') { |file| file.write(YAML.dump(self)) }
    puts '***SAVED****'
    exit
  end
end

new_game = Game.new
# new_game.turn = 2
new_game.play
# new_game.game.move([1, 3], [5, 3])
# new_game.game.move([1, 4], [5, 2])
# new_game.game.move([7, 2], [4, 0])
# new_game.game.move([0, 6], [1, 4])
# new_game.game.move([1, 5], [2, 5])
# new_game.game.move([7, 0], [5, 4])
# new_game.game.board
# new_game.checkmate?
