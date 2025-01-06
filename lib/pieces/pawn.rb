require_relative 'piece'

# Pawn
class Pawn < Piece
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2659" : "\u265F"
    # maybe put each pieces pos here?
  end

  def moves
    possible_moves = [[@dir, 0]]
    possible_moves.append([@dir * 2, 0]) unless moved
    possible_moves
  end
end
