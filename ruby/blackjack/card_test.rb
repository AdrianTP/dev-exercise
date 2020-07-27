require 'test/unit'
require './card.rb'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end

  def test_card_suit_is_correct
    assert_equal :hearts, @card.suit
  end

  def test_card_name_is_correct
    assert_equal :ten, @card.name
  end

  def test_card_value_is_correct
    assert_equal 10, @card.value
  end
end
