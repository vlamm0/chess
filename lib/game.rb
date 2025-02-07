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
    player.prompt

    winner = false
    end?(winner)
  end

  def turn?
    turn.even? ? players[0] : players[1]
  end

  def end?(winner)
    color = turn?.color
    @turn += 1
    # breaks infinite loop, temp.
    winner = true if turn > 21
    print winner ? "\n#{color} wins!\n" : go
  end
end

Game.new.go
