# King
class King
  attr_accessor :sym

  def initialize(col = 1)
    @sym = col == 1 ? "\u2655" : "\u265B"
  end
end
