# Data
module MyData
  @data = Array.new(8) { Array.new(8, '') }

  # Set up the black pieces
  @data[0][0] = Rook.new('black')
  @data[0][1] = Knight.new('black')
  @data[0][2] = Bishop.new('black')
  @data[0][3] = Queen.new('black')
  @data[0][4] = King.new('black')
  @data[0][5] = Bishop.new('black')
  @data[0][6] = Knight.new('black')
  @data[0][7] = Rook.new('black')

  # Set up the black pawns
  8.times { |i| @data[1][i] = Pawn.new('black') }

  4.times { |i| @data[i + 2] = Array.new(8, '') }

  # Set up the white pieces
  @data[7][0] = Rook.new('white')
  @data[7][1] = Knight.new('white')
  @data[7][2] = Bishop.new('white')
  @data[7][3] = Queen.new('white')
  @data[7][4] = King.new('white')
  @data[7][5] = Bishop.new('white')
  @data[7][6] = Knight.new('white')
  @data[7][7] = Rook.new('white')

  8.times { |i| @data[6][i] = Pawn.new('white') }

  def self.board
    @data
  end
end
