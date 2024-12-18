# requires files
folder = '/home/zach/ODIN/chess/lib/pieces'
files = Dir.entries(folder).reject { |f| ['.', '..'].include?(f) }
files.each { |file| require_relative "./pieces/#{file}" }
require_relative 'data'

# Chess
class Chess
  attr_accessor :data

  def initialize
    @data = MyData.board # Array.new(8) { Array.new(8, '') }
  end

  def draw_square(row, col, piece = data[row][col])
    light_square = piece == '' ? "\e[48;5;255m   \e[0m" : "\e[48;5;255m \e[38;5;0m#{piece.sym} \e[0m"
    dark_square = piece == '' ? "\e[48;5;244m   \e[0m" : "\e[48;5;244m \e[38;5;0m#{piece.sym} \e[0m"
    (row + col).even? ? light_square : dark_square
  end

  def chessboard
    # Loop to create 8 rows of chessboard
    alph = %w[A B C D E F G H]
    8.times { |i| print i != 0 ? " #{i} " : "   #{i} " }
    puts
    8.times do |row|
      print "#{alph[row]} "
      8.times { |col| print draw_square(row, col) }
      puts
    end
  end
end

game = Chess.new
game.chessboard
