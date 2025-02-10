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

  def go(player = turn?)
    game.board
    game.select(valid_piece?(player.prompt, player.color))

    winner = true
    end?(winner)
  end

  def turn?
    turn.even? ? players[0] : players[1]
  end

  def valid_piece?(pos, color)
    cleanse(turn?.prompt(true), color) if pos.nil?
    game.on_board?(pos) && game.same_team?(color, game.get_piece(pos)) ? pos : cleanse(turn?.prompt(true))
  end

  def end?(winner)
    color = turn?.color
    @turn += 1
    # breaks infinite loop, temp.
    winner = true if turn > 21
    print winner ? "\n#{color} wins!\n" : go
  end
end

# Game.new.check_for_digits(%w[B 6])
Game.new.go
