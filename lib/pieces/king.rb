require_relative 'piece'

# King
class King < Piece
  include Directions
  include Gallop
  include PawnAtks
  attr_accessor :sym, :dir, :color, :moved

  def initialize(color)
    super
    @sym = color == 'white' ? "\u2654" : "\u265A"
    @dir = color == 'white' ? -1 : 1
  end

  def moves
    [hor, vert, diag1, diag2].flatten
  end

  def attacks(row, col)
    knight_atks = travails.map { |proc| proc.call([row, col]) }
    atk_vector = knight_atks + atks(row, col)
    atk_vector.filter { |move| on_board?(move) }
  end
end

pp King.new('white').attacks(7, 7)
