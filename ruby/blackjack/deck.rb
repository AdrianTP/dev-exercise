require './card.rb'

class Deck
  attr_accessor :playable_cards
  SUITS = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def draw_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = SUITS.each_with_object([]) do |suit, cards|
      NAME_VALUES.each do |name, value|
        cards << Card.new(suit, name, value)
      end
    end
  end
end
