# get requirements
require_relative './chess'
require_relative './player'

# game
class Game
  attr_accessor :players, :game, :turn

  def initialize
    @players = [Player.new, Player.new]
    @game = Chess.new
    @turn = 0
  end

  def play
    curr, to = select
    game.move(curr, to)
    game.board
    end?(false)
  end

  # select (valid) piece and destination
  def select(player = whos_turn)
    game.board
    piece, destination = ensure_move(valid_piece?(player.prompt, player.color))
    return [piece, destination] if game.select(piece).include?(destination)

    puts "\n\n***INVALID MOVE***"
    select
  end

  def whos_turn
    turn.even? ? players[0] : players[1]
  end

  def ensure_move(piece)
    game.select(piece)
    piece, destination = handle_canceling(piece)
    destination = whos_turn.standardize(destination.split(''))
    destination.nil? || destination.length != 2 ? ensure_move(piece) : [piece, destination]
  end

  def handle_canceling(piece, player = whos_turn)
    puts 'Where to? (enter x to select a different piece)'
    destination = gets.chomp
    return [piece, destination] if destination.downcase != 'x'

    game.board
    [valid_piece?(player.prompt, player.color), destination]
  end

  def valid_piece?(pos, color)
    valid_piece?(whos_turn.prompt(true), color) if pos.nil?
    if game.on_board?(pos) && game.same_team?(color, game.get_piece(pos))
      pos
    else
      valid_piece?(whos_turn.prompt(true), color)
    end
  end

  def end?(winner)
    color = whos_turn.color
    @turn += 1
    # breaks infinite loop, temp.
    winner = true if turn > 21
    print winner ? "\n#{color} wins!\n" : play
  end
end

Game.new.play
