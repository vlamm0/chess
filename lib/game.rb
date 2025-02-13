# get requirements
require_relative './chess'
require_relative './player'

# game
class Game
  attr_accessor :players, :game, :turn

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

      move
      # curr, to = select
      # game.move(curr, to)
      # whos_turn.king = to if game.get_piece(curr).is_a?(King)
      # game.board
      @turn += 1
    end
    puts "\n#{color} wins!\n"
  end

  def checkmate?(king = whos_turn.king)
    # change to checkmate? function
    pp game.check?(king)
    # game.board
    false
    # @turn += 1 unless checkmate
    # breaks infinite loop, temp.
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
