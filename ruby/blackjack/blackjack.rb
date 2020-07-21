### Simplified Blackjack

# `blackjack.rb` contains initial work on a Blackjack game.

# Your implementation should complete the initial work on the game and satisfy the following use cases and Blackjack rules:

#  * As a Player I can get a hand with two cards in it
#  * As a Dealer I can get a hand with two cards in it
#  * As a Player I can see what card the dealer is showing
#  * As a Player I can blackjack (win immediately) when I am dealt cards (this is a simplification)
#  * As a Player I can bust (lose immediately) when I am getting cards
#  * As a Dealer I can draw cards after the player until I win or lose
#  * At the end of the round (after the Dealer's turn), the result of the round is determined

# **Rules:**

#  * Bust - Occurs when all possible hand values are greater than 21 points
#  * Blackjack - Occurs when a player or dealer is dealt an ace and a 10-point card
#  * Dealer - Stays on 17 or above
#  * Round Flow - Player acts first, then the dealer acts if necessary

# Please use your discretion in fixing/adding tests. You are free to use/convert to any testing framework you want.

# For more information on blackjack, please refer to its [wiki page](http://en.wikipedia.org/wiki/Blackjack).

class Card
  attr_accessor :suit, :name, :value

  def initialize(suit, name, value)
    @suit, @name, @value = suit, name, value
  end
end

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

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITS.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end
end

require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end
  
  def test_card_suit_is_correct
    assert_equal @card.suit, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end
  
  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end
  
  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert(@deck.playable_cards.include?(card))
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end