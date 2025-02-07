# player
class Player
  @num_player = 0
  attr_accessor :color, :num_player

  def initialize
    self.class.instance_variable_set(:@num_player, self.class.instance_variable_get(:@num_player) + 1)
    self.color = self.class.instance_variable_get(:@num_player) == 1 ? 'white' : 'black'
  end

  def prompt
    puts "It is #{color}'s turn:"
  end
end
