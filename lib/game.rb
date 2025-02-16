# get requirements
require_relative './chess'
require_relative './player'

# game
class Game
  attr_accessor :players, :game, :turn, :check

  def initialize
    @players = [Player.new, Player.new]
    @game = Chess.new
    @turn = 1
  end

  # loop through player turn until ending (not recursive to prevent stack overflow)
  def play
    until checkmate?
      # prevent infinite loop while testing
      break if turn > 100

      game.checks ? defend : move
      # curr, to = select
      # game.move(curr, to)
      # whos_turn.king = to if game.get_piece(curr).is_a?(King)
      # game.board
      @turn += 1
    end
    puts "\n#{color} wins!\n"
  end

  def escape?(king)
    stack = []
    # piece = game.get_piece(king)
    possible_moves = game.get_moves(king, game.get_piece(king))
    possible_moves.each do |to|
      stack.push(game.get_piece(to))
      game.move(king, to)
      check = game.check?(to)
      game.move(to, king)
      game.data[to[0]][to[1]] = stack.pop
      return true unless check
    end
    false
  end

  def checkmate?(king = whos_turn.king)
    # change to checkmate? function

    return false unless game.check?(king) # is king in check (if so also stores attacks in game.check)

    existing_checks = game.checks
    pp existing_checks

    pp escape?(king)

    # shied function : can a piece move to all of the
    # I need k/v pairs
    # !escape && !shield ? return true : game.check = existing_checks
    game.checks = existing_checks
    pp game.checks

    # game.board
    false
    # @turn += 1 unless checkmate
  end

  def move
    curr, to = select
    game.move(curr, to)
    whos_turn.king = to if game.get_piece(curr).is_a?(King)
    game.board
  end

  # select (valid) piece and destination
  def select(player = whos_turn)
    game.board
    piece, destination = standardize(your_piece(player.prompt, player.color))
    return [piece, destination] if game.select(piece).include?(destination)

    puts "\n\n***INVALID MOVE***"
    select
  end

  # get player based on the turn
  def whos_turn
    turn.even? ? players[1] : players[0]
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

  # def checkmate?(king = whos_turn.king)
  #   pp game.check?(king)
  #   game.board
  # end
end

new_game = Game.new
new_game.turn = 2
# new_game.play
new_game.game.move([1, 3], [5, 3])
new_game.game.move([1, 4], [5, 2])
new_game.game.move([7, 2], [4, 0])
new_game.game.board
new_game.checkmate?
