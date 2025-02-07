require_relative 'piece'

# Pawn
class Pawn < Piece
  include PawnAtks
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2659" : "\u265F"
    @dir = color == 'white' ? -1 : 1
  end

  # NOTE: pawn needs board data to determine available moves (represented by blocks)
  def moves(blocks, available_moves = [])
    procs = [spacex1, spacex2, left_atk, right_atk].flatten
    blocks.each_with_index do |block, i|
      available_moves.append(procs[i]) if block
    end
    available_moves
  end

  # move one space
  def spacex1
    proc { |pos| [@dir + pos[0], pos[1]] }
  end

  # move two spaces
  def spacex2
    proc { |pos| moved ? nil : [@dir + @dir + pos[0], pos[1]] }
  end
end
