require_relative 'piece'

# Rook
class Rook < Piece
  include Directions
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2656" : "\u265C"
  end

  # this is a list of procs to use with recursive testing on the board
  def moves
    [vert, hor].flatten
  end
end
