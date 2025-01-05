# requires files
folder = '/home/zach/ODIN/chess/lib/pieces'
files = Dir.entries(folder).reject { |f| ['.', '..'].include?(f) }
files.each { |file| require_relative "./pieces/#{file}" }
require_relative 'data'

# Chess
class Chess
  attr_accessor :data

  # uses the required data file for state, start or saved (to be implemented!)
  def initialize
    @data = MyData.board
  end

  # draws a chess tile with the piece data
  def draw_tile(row, col, piece = data[row][col])
    light_square = piece == '' ? "\e[48;5;255m   \e[0m" : "\e[48;5;255m \e[38;5;0m#{piece.sym} \e[0m"
    dark_square = piece == '' ? "\e[48;5;244m   \e[0m" : "\e[48;5;244m \e[38;5;0m#{piece.sym} \e[0m"
    (row + col).even? ? light_square : dark_square
  end

  # draws the entire board, including the row/col headers
  def chessboard
    # Loop to create 8 rows of chessboard
    alph = %w[A B C D E F G H]
    8.times { |i| print i != 0 ? " #{i} " : "   #{i} " }
    puts
    8.times do |row|
      print "#{alph[row]} "
      8.times { |col| print draw_tile(row, col) }
      puts
    end
  end
end

game = Chess.new
game.chessboard
