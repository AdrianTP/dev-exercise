require 'test/unit'
require './deck.rb'

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end

  def test_new_deck_has_52_playable_cards
    assert_equal 52, @deck.playable_cards.size
  end

  def test_drawn_card_should_not_be_included_in_playable_cards
    card = @deck.draw_card
    assert_false @deck.playable_cards.include?(card)
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal 52, @deck.playable_cards.size
  end
end
