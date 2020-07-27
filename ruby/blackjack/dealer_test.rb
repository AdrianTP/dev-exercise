require 'test/unit'
require './dealer.rb'
require './test_helpers/mocks.rb'

class DealerTest < Test::Unit::TestCase
  include Mocks

  def setup
    inject_card_mocks
    inject_mockable_deck
    @dealer = Dealer.new
  end

  def stack_deck
    @deck.stack([@two, @three, @four, @five, @six, @seven])
  end

  # initialize
  # name
  def test_initialize_default_score_zero
    assert_equal 0, @dealer.score
  end

  def test_initialize_default_upcards_empty
    assert_equal [], @dealer.upcards
  end

  def test_initialize_default_flipped_false
    assert_false @dealer.flipped?
  end

  def test_initialize_default_name_dealer
    assert_equal 'Dealer', @dealer.name
  end

  def test_initialize_does_not_accept_name_argument
    assert_raise { Dealer.new('Mengde') }
  end

  # deal_starting_hand
  def test_deal_starting_hand_gives_players_and_self_two_cards
    stack_deck
    players = [Player.new, Player.new]
    @dealer.deal_starting_hand(@deck, players)
    assert_equal [@two, @five], players.first.upcards
    assert_equal [@three, @six], players.last.upcards
    @dealer.flip
    assert_equal [@four, @seven], @dealer.upcards
  end

  # flip
  def test_flip_changes_flipped
    assert_false @dealer.flipped?
    @dealer.flip
    assert_true @dealer.flipped?
  end

  def test_flip_moves_hole_card_to_upcards
    [@ten, @two].each { |c| @dealer.receive_card(c) }
    @dealer.flip
    assert_equal [@ten, @two], @dealer.upcards
  end

  # hit
  def test_hit_gives_designated_player_designated_card
    player = Player.new
    @dealer.hit(player, @five)
    assert_equal [@five], player.upcards
  end

  # limit
  def test_limit_influences_standing
    [@ten, @four].each { |c| @dealer.receive_card(c) }
    assert_false @dealer.standing?
    @dealer.receive_card(@three)
    assert_true @dealer.standing?
  end

  def test_dealer_stands_on_hard_seventeen
    [@seven, @ten].each { |c| @dealer.receive_card(c) }
    assert_true @dealer.standing?
  end

  def test_dealer_hits_on_soft_seventeen
    [@six, @ace].each { |c| @dealer.receive_card(c) }
    assert_true @dealer.ready?
  end

  # prepare
  def test_prepare_resets_score_and_upcards_and_flipped
    [@ten, @king].each { |c| @dealer.receive_card(c) }
    assert_false @dealer.flipped?
    @dealer.flip
    assert_true @dealer.flipped?
    assert_equal 20, @dealer.score
    assert_equal [@ten, @king], @dealer.upcards
    @dealer.prepare
    assert_false @dealer.flipped?
    assert_equal 0, @dealer.score
    assert_equal [], @dealer.upcards
  end

  # receive_card
  def test_receive_card_updates_upcards
    assert_equal [], @dealer.upcards
    @dealer.flip
    [@ten, @five, @two].each { |c| @dealer.receive_card(c) }
    assert_equal [@ten, @five, @two], @dealer.upcards
  end

  # score
  def test_score_updates_on_receive_card
    assert_equal 0, @dealer.score
    @dealer.receive_card(@five)
    @dealer.flip
    assert_equal 5, @dealer.score
  end

  # upcards
  def test_upcards_shows_cards_in_hand_except_first_when_not_flipped
    assert_equal [], @dealer.upcards
    @dealer.receive_card(@ten)
    assert_equal [], @dealer.upcards
    @dealer.receive_card(@two)
    assert_equal [@two], @dealer.upcards
    @dealer.receive_card(@king)
    assert_equal [@two, @king], @dealer.upcards
    @dealer.flip
    assert_equal [@ten, @two, @king], @dealer.upcards
  end

  # blackjack?
  def test_false_when_score_equals_twenty_one_with_more_than_two_cards
    assert_false @dealer.blackjack?
    [@ten, @eight, @three].each { |c| @dealer.receive_card(c) }
    assert_false @dealer.blackjack?
  end

  def test_true_when_score_equals_twenty_one_with_exactly_two_cards
    assert_false @dealer.blackjack?
    [@ten, @ace].each { |c| @dealer.receive_card(c) }
    assert_true @dealer.blackjack?
  end

  # busted?
  def test_busted_false_when_score_below_twenty_one
    assert_false @dealer.busted?
    [@ten, @eight, @two].each { |c| @dealer.receive_card(c) }
    assert_false @dealer.busted?
  end

  def test_busted_false_when_score_exactly_twenty_one
    assert_false @dealer.busted?
    [@ten, @eight, @three].each { |c| @dealer.receive_card(c) }
    assert_false @dealer.busted?
  end

  def test_busted_true_when_score_over_twenty_one
    assert_false @dealer.busted?
    [@ten, @eight, @four].each { |c| @dealer.receive_card(c) }
    assert_true @dealer.busted?
  end

  # flipped?
  def test_dealer_flips_automatically_on_blackjack
    assert_false @dealer.flipped?
    [@ten, @ace].each { |c| @dealer.receive_card(c) }
    assert_true @dealer.flipped?
  end

  # ready?
  def test_ready_true_when_score_below_limit
    @dealer.limit = 16
    assert_true @dealer.ready?
    [@ten, @five].each { |c| @dealer.receive_card(c) }
    assert_true @dealer.ready?
  end

  def test_ready_false_when_score_exactly_limit
    @dealer.limit = 16
    assert_true @dealer.ready?
    [@ten, @six].each { |c| @dealer.receive_card(c) }
    assert_false @dealer.ready?
  end

  def test_ready_true_when_score_above_limit
    @dealer.limit = 16
    assert_true @dealer.ready?
    [@ten, @seven].each { |c| @dealer.receive_card(c) }
    assert_false @dealer.ready?
  end

  # standing?
  def test_standing_false_when_score_below_limit
    @dealer.limit = 16
    assert_false @dealer.standing?
    [@ten, @five].each { |c| @dealer.receive_card(c) }
    assert_false @dealer.standing?
  end

  def test_standing_true_when_score_exactly_limit
    @dealer.limit = 16
    assert_false @dealer.standing?
    [@ten, @six].each { |c| @dealer.receive_card(c) }
    assert_true @dealer.standing?
  end

  def test_standing_true_when_score_above_limit
    @dealer.limit = 16
    assert_false @dealer.standing?
    [@ten, @seven].each { |c| @dealer.receive_card(c) }
    assert_true @dealer.standing?
  end

  # target?
  def test_false_when_score_below_twenty_one
    assert_false @dealer.target?
    [@ten, @eight, @two].each { |c| @dealer.receive_card(c) }
    assert_false @dealer.target?
  end

  def test_false_when_score_over_twenty_one
    assert_false @dealer.target?
    [@ten, @eight, @four].each { |c| @dealer.receive_card(c) }
    assert_false @dealer.target?
  end

  def test_true_when_score_exactly_twenty_one_with_two_cards
    assert_false @dealer.target?
    [@ten, @ace].each { |c| @dealer.receive_card(c) }
    assert_true @dealer.target?
  end

  def test_true_when_score_exactly_twenty_one_with_more_than_two_cards
    assert_false @dealer.target?
    [@ten, @eight, @three].each { |c| @dealer.receive_card(c) }
    assert_true @dealer.target?
  end

  # waiting?
  def test_waiting
    assert_true @dealer.waiting?
    @dealer.receive_card(@two)
    assert_true @dealer.waiting?
    @dealer.receive_card(@three)
    assert_false @dealer.waiting?
  end
end
