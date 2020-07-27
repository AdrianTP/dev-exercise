require 'test/unit'
require './player.rb'
require './test_helpers/mocks.rb'

class PlayerTest < Test::Unit::TestCase
  include Mocks

  def setup
    inject_card_mocks
    @player = Player.new
  end

  # initialize
  # name
  def test_initialize_default_unique_name
    other = Player.new
    assert_not_equal @player, other
  end

  def test_initialize_accepts_name
    kongming = Player.new('Kongming')
    zhongda = Player.new('Zhongda')
    assert_not_equal kongming, zhongda
    assert_equal 'Kongming', kongming.name
    assert_equal 'Zhongda', zhongda.name
  end

  def test_initialize_default_score_zero
    assert_equal 0, @player.score
  end

  def test_initialize_default_upcards_empty
    assert_equal [], @player.upcards
  end

  # limit
  def test_limit_influences_standing
    @player.limit = 16
    [@ten, @four].each { |c| @player.receive_card(c) }
    assert_false @player.standing?
    @player.receive_card(@two)
    assert_true @player.standing?
  end

  # prepare
  def test_prepare_resets_score_and_upcards
    [@ten, @ace].each { |c| @player.receive_card(c) }
    assert_equal 21, @player.score
    assert_equal [@ten, @ace], @player.upcards
    @player.prepare
    assert_equal 0, @player.score
    assert_equal [], @player.upcards
  end

  # receive_card
  def test_receive_card_updates_upcards
    [@ten, @five, @two].each { |c| @player.receive_card(c) }
    assert_equal [@ten, @five, @two], @player.upcards
  end

  # score
  def test_score_updates_on_receive_card
    @player.receive_card(@five)
    assert_equal 5, @player.score
    @player.receive_card(@ace)
    assert_equal 16, @player.score
    @player.receive_card(@six)
    assert_equal 12, @player.score
  end

  # upcards
  def test_upcards_shows_cards_in_hand
    assert_equal [], @player.upcards
    @player.receive_card(@ten)
    assert_equal [@ten], @player.upcards
    @player.receive_card(@two)
    assert_equal [@ten, @two], @player.upcards
    @player.receive_card(@king)
    assert_equal [@ten, @two, @king], @player.upcards
  end

  # blackjack?
  def test_false_when_score_equals_twenty_one_with_more_than_two_cards
    assert_false @player.blackjack?
    [@ten, @eight, @three].each { |c| @player.receive_card(c) }
    assert_false @player.blackjack?
  end

  def test_true_when_score_equals_twenty_one_with_exactly_two_cards
    assert_false @player.blackjack?
    [@ten, @ace].each { |c| @player.receive_card(c) }
    assert_true @player.blackjack?
  end

  # busted?
  def test_busted_false_when_score_below_twenty_one
    assert_false @player.busted?
    [@ten, @eight, @two].each { |c| @player.receive_card(c) }
    assert_false @player.busted?
  end

  def test_busted_false_when_score_exactly_twenty_one
    assert_false @player.busted?
    [@ten, @eight, @three].each { |c| @player.receive_card(c) }
    assert_false @player.busted?
  end

  def test_busted_true_when_score_over_twenty_one
    assert_false @player.busted?
    [@ten, @eight, @four].each { |c| @player.receive_card(c) }
    assert_true @player.busted?
  end

  # dealt?
  def test_dealt_false_when_less_than_two_cards
    assert_false @player.dealt?
    @player.receive_card(@two)
    assert_false @player.dealt?
  end

  def test_dealt_true_when_two_or_more_cards
    [@two, @three].each { |c| @player.receive_card(c) }
    assert_true @player.dealt?
    @player.receive_card(@four)
    assert_true @player.dealt?
  end

  # ready?
  def test_ready_true_when_score_below_limit
    @player.limit = 16
    assert_true @player.ready?
    [@ten, @five].each { |c| @player.receive_card(c) }
    assert_true @player.ready?
  end

  def test_ready_false_when_score_exactly_limit
    @player.limit = 16
    assert_true @player.ready?
    [@ten, @six].each { |c| @player.receive_card(c) }
    assert_false @player.ready?
  end

  def test_ready_true_when_score_above_limit
    @player.limit = 16
    assert_true @player.ready?
    [@ten, @seven].each { |c| @player.receive_card(c) }
    assert_false @player.ready?
  end

  # standing?
  def test_standing_false_when_score_below_limit
    @player.limit = 16
    assert_false @player.standing?
    [@ten, @five].each { |c| @player.receive_card(c) }
    assert_false @player.standing?
  end

  def test_standing_true_when_score_exactly_limit
    @player.limit = 16
    assert_false @player.standing?
    [@ten, @six].each { |c| @player.receive_card(c) }
    assert_true @player.standing?
  end

  def test_standing_true_when_score_above_limit
    @player.limit = 16
    assert_false @player.standing?
    [@ten, @seven].each { |c| @player.receive_card(c) }
    assert_true @player.standing?
  end

  # target?
  def test_false_when_score_below_twenty_one
    assert_false @player.target?
    [@ten, @eight, @two].each { |c| @player.receive_card(c) }
    assert_false @player.target?
  end

  def test_false_when_score_over_twenty_one
    assert_false @player.target?
    [@ten, @eight, @four].each { |c| @player.receive_card(c) }
    assert_false @player.target?
  end

  def test_true_when_score_exactly_twenty_one_with_two_cards
    assert_false @player.target?
    [@ten, @ace].each { |c| @player.receive_card(c) }
    assert_true @player.target?
  end

  def test_true_when_score_exactly_twenty_one_with_more_than_two_cards
    assert_false @player.target?
    [@ten, @eight, @three].each { |c| @player.receive_card(c) }
    assert_true @player.target?
  end

  # waiting?
  def test_waiting
    assert_true @player.waiting?
    @player.receive_card(@two)
    assert_true @player.waiting?
    @player.receive_card(@three)
    assert_false @player.waiting?
  end
end
