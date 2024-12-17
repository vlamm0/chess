# Chess
class Chess
  attr_accessor :data, :pawn

  def initialize
    @data = Array.new(8) { Array.new(8, '') }
  end

  def draw_square(row, col, piece = data[row][col])
    black_pawn = "\u265F"
    light_square = piece.nil? ? "\e[48;5;250m   \e[0m" : "\e[48;5;250m #{black_pawn} \e[0m" # Light square (off-white)
    dark_square = piece.nil? ? "\e[48;5;235m   \e[0m" : "\e[48;5;235m \e[38;5;0m#{black_pawn}\e[48;5;235m \e[0m" # Dark square (dark gray)
    (row + col).even? ? light_square : dark_square
  end

  def chessboard
    # Loop to create 8 rows of chessboard
    8.times do |row|
      8.times { |col| print draw_square(row, col) }
      puts
    end
  end
end

game = Chess.new
game.chessboard
