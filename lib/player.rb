# player
class Player
  ALPH = %w[A B C D E F G H].freeze
  @num_player = 0
  attr_accessor :color, :num_player

  def initialize
    self.class.instance_variable_set(:@num_player, self.class.instance_variable_get(:@num_player) + 1)
    self.color = self.class.instance_variable_get(:@num_player) == 1 ? 'white' : 'black'
  end

  def opponent
    color == 'white' ? 'black' : 'white'
  end

  def prompt(explain = nil)
    puts '***Only put 1 letter and 1 number representing the piece***' if explain
    puts "Select your piece to move #{color}:" if explain.nil?
    validate_input(gets.chomp.split(''))
    # standardize(input)
    # pos = input.length == 2 ? standardize(input) : prompt(true)
    # pos.nil? ? prompt(true) : pos
  end

  def validate_input(input)
    pos = input.length == 2 ? standardize(input) : prompt(true)
    pos.nil? ? prompt(true) : pos
  end

  def standardize(pos, num = -1)
    # puts 'moving through stand'
    pos.each { |elem| num = pos.delete(elem).to_i if elem.match?(/^\d+$/) }
    # tmp for testing
    # puts "letter: #{pos[0]} num: #{num}"
    return nil unless ALPH.include?(pos[0]&.upcase)

    num != -1 && pos.length == 1 ? [num, ALPH.index(pos[0].upcase)] : nil
  end
end

# pp Player.new.prompt
