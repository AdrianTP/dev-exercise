require 'test/unit'
require './game.rb'
require './test_helpers/mocks.rb'

class GameTest < Test::Unit::TestCase
  include Mocks

  class TestableGame < Game
    attr_accessor :deck

    attr_reader :dealer, :players
  end

  def init_game_with_num_players(num_players)
    @game = TestableGame.new(num_players)
    @game.deck = @deck
  end

  # borrowed from https://gist.github.com/moertel/11091573
  def suppress_output
    original_stderr = $stderr.clone
    original_stdout = $stdout.clone
    $stderr.reopen(File.new('/dev/null', 'w'))
    $stdout.reopen(File.new('/dev/null', 'w'))
    yield
  ensure
    $stdout.reopen(original_stdout)
    $stderr.reopen(original_stderr)
  end

  def setup
    inject_card_mocks
    inject_mockable_deck
  end

  def test_play_dealer_blackjack_player_twenty_game_ends_immediately_dealer_wins
    init_game_with_num_players(1)
    @deck.stack([@ace, @ten, @nine, @ace, @two, @three])
    suppress_output { @game.play }
    assert_true @game.dealer.blackjack?
    assert_equal 20, @game.players.first.score
    assert_empty @game.blackjacks
    assert_not_empty @game.losers
    assert_empty @game.pushes
    assert_empty @game.winners
    assert_equal [@two, @three], @deck.playable_cards
  end

  def test_play_dealer_blackjack_player_blackjack_game_ends_immediately_push
    init_game_with_num_players(1)
    @deck.stack([@ace, @ten, @king, @ace, @two, @three])
    suppress_output { @game.play }
    assert_true @game.dealer.blackjack?
    assert_true @game.players.first.blackjack?
    assert_empty @game.blackjacks
    assert_empty @game.losers
    assert_not_empty @game.pushes
    assert_empty @game.winners
    assert_equal [@two, @three], @deck.playable_cards
  end

  def test_play_push_same_score_dealer_hit_soft_seventeen
    init_game_with_num_players(1)
    @game.players.first.limit = 18
    @deck.stack([@ace, @ace, @six, @six, @five, @six, @ace, @two, @three])
    suppress_output { @game.play }
    assert_equal 18, @game.dealer.score
    assert_equal 18, @game.players.first.score
    assert_empty @game.blackjacks
    assert_empty @game.losers
    assert_not_empty @game.pushes
    assert_empty @game.winners
    assert_equal [@two, @three], @deck.playable_cards
  end

  def test_play_dealer_stands_hard_17_players_vary
    init_game_with_num_players(6)
    # players: 1     2     3     4     5    6     Dealer
    # limits:  18    16    18    17    16   16    17h/18s
    # cards:   king  queen nine  five  jack five  nine
    #          seven ace   five  four  five queen two
    #          king        three two   ace  three six
    #                      four  ace
    #                            two
    #                            three
    # scores:  27    bj    21    17    16   18    17
    # result:  bust  bj    win   push  lose win   ...
    @game.players[0].limit = 18
    @game.players[1].limit = 16
    @game.players[2].limit = 18
    @game.players[3].limit = 17
    @game.players[4].limit = 16
    @game.players[5].limit = 18
    @deck.stack([@king, @queen, @nine, @five, @jack, @five, @nine, @seven, @ace,
                 @five, @four, @five, @queen, @two, @king, @three, @four, @two,
                 @ace, @two, @three, @ace, @three, @six, @queen, @seven])
    suppress_output { @game.play }
    assert_equal 17, @game.dealer.score
    # player 1
    assert_equal 27, @game.players[0].score
    assert_true @game.players[0].busted?
    # player 2
    assert_equal 21, @game.players[1].score
    assert_true @game.players[1].target?
    assert_true @game.players[1].blackjack?
    # player 3
    assert_equal 21, @game.players[2].score
    assert_true @game.players[2].target?
    assert_false @game.players[2].blackjack?
    # player 4
    assert_equal 17, @game.players[3].score
    # player 5
    assert_equal 16, @game.players[4].score
    # player 6
    assert_equal 18, @game.players[5].score
    assert_equal [@game.players[1]], @game.blackjacks
    assert_equal [@game.players[0], @game.players[4]], @game.losers
    assert_equal [@game.players[3]], @game.pushes
    assert_equal [@game.players[2], @game.players[5]], @game.winners
    assert_equal [@queen, @seven], @deck.playable_cards
  end

  def test_play_dealer_busts_players_vary
    init_game_with_num_players(6)
    # players: 1     2     3     4     5    6     Dealer
    # limits:  18    16    18    17    16   16    17h/18s
    # cards:   king  queen nine  five  jack five  nine
    #          seven ace   five  four  five queen six
    #          king        three two   ace  three king
    #                      four  ace
    #                            two
    #                            three
    # scores:  27    bj    21    17    16   18    25
    # result:  bust  bj    win   win   win  win   ...
    @game.players[0].limit = 18
    @game.players[1].limit = 16
    @game.players[2].limit = 18
    @game.players[3].limit = 17
    @game.players[4].limit = 16
    @game.players[5].limit = 18
    @deck.stack([@king, @queen, @nine, @five, @jack, @five, @nine, @seven, @ace,
                 @five, @four, @five, @queen, @six, @king, @three, @four, @two,
                 @ace, @two, @three, @ace, @three, @king, @queen, @seven])
    suppress_output { @game.play }
    assert_equal 25, @game.dealer.score
    # player 1
    assert_equal 27, @game.players[0].score
    assert_true @game.players[0].busted?
    # player 2
    assert_equal 21, @game.players[1].score
    assert_true @game.players[1].target?
    assert_true @game.players[1].blackjack?
    # player 3
    assert_equal 21, @game.players[2].score
    assert_true @game.players[2].target?
    assert_false @game.players[2].blackjack?
    # player 4
    assert_equal 17, @game.players[3].score
    # player 5
    assert_equal 16, @game.players[4].score
    # player 6
    assert_equal 18, @game.players[5].score
    assert_equal [@game.players[1]], @game.blackjacks
    assert_equal [@game.players[0]], @game.losers
    assert_empty @game.pushes
    assert_equal [@game.players[2], @game.players[3], @game.players[4], @game.players[5]], @game.winners
    assert_equal [@queen, @seven], @deck.playable_cards
  end
end
