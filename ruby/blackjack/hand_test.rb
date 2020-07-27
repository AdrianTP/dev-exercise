require 'test/unit'
require './hand.rb'
require './test_helpers/mocks.rb'

class HandTest < Test::Unit::TestCase
  include Mocks

  def setup
    inject_card_mocks
    @hand = Hand.new
  end

  # initialize
  def test_cards_empty_when_new
    assert_equal [], @hand.cards
  end

  # add_card
  # cards
  def test_cards_lists_cards
    [@seven, @five, @two].each { |c| @hand.add_card(c) }
    assert_equal [@seven, @five, @two], @hand.cards
  end

  # score
  def test_score_increases_for_each_card_and_handles_aces_properly
    assert_equal 0, @hand.score
    @hand.add_card(@seven)
    assert_equal 7, @hand.score
    @hand.add_card(@ace)
    assert_equal 18, @hand.score
    @hand.add_card(@ace)
    assert_equal 19, @hand.score
    @hand.add_card(@two)
    assert_equal 21, @hand.score
    @hand.add_card(@ace)
    assert_equal 12, @hand.score
    @hand.add_card(@king)
    assert_equal 22, @hand.score
  end

  # dealt?
  def test_dealt_false_when_less_than_two_cards
    assert_false @hand.dealt?
    @hand.add_card(@two)
    assert_false @hand.dealt?
  end

  def test_dealt_true_when_two_or_more_cards
    [@two, @three].each { |c| @hand.add_card(c) }
    assert_true @hand.dealt?
    @hand.add_card(@four)
    assert_true @hand.dealt?
  end

  # blackjack?
  def test_blackjack_false_when_two_cards_and_not_twenty_one
    [@ace, @ace].each { |c| @hand.add_card(c) }
    assert_false @hand.blackjack?
  end

  def test_blackjack_false_when_more_than_two_cards_exactly_twenty_one
    [@ace, @eight, @two].each { |c| @hand.add_card(c) }
    assert_false @hand.blackjack?
  end

  def test_blackjack_true_when_two_cards_exactly_twenty_one
    [@ace, @ten].each { |c| @hand.add_card(c) }
    assert_true @hand.blackjack?
  end

  # bust?
  def test_bust_false_under_twenty_one
    [@ten, @jack].each { |c| @hand.add_card(c) }
    assert_false @hand.bust?
    @hand.add_card(@ace)
    assert_false @hand.bust?
  end

  def test_bust_true_over_twenty_one
    [@ten, @jack].each { |c| @hand.add_card(c) }
    assert_false @hand.bust?
    @hand.add_card(@two)
    assert_true @hand.bust?
  end

  # soft?
  def test_soft_when_ace_as_eleven
    assert_false @hand.soft?
    @hand.add_card(@six)
    assert_false @hand.soft?
    @hand.add_card(@ace)
    assert_true @hand.soft?
    @hand.add_card(@five)
    assert_false @hand.soft?
  end

  # target?
  def test_target_false_below_or_above_twenty_one
    [@ten, @jack].each { |c| @hand.add_card(c) }
    assert_false @hand.target?
    @hand.add_card(@ten)
    assert_false @hand.target?
  end

  def test_target_true_exactly_twenty_one
    [@ten, @ace].each { |c| @hand.add_card(c) }
    assert_true @hand.target?
  end
end
