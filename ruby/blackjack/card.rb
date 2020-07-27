class Card
  attr_reader :suit, :name, :value

  def initialize(suit, name, value)
    @suit, @name, @value = suit, name, value
  end
end
