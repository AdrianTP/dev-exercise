require './deck.rb'
require './player.rb'
require './dealer.rb'
require './helpers/card_print_helper.rb'

class Game
  include CardPrintHelper

  attr_reader :blackjacks, :losers, :pushes, :winners

  # executive decision: this table has 6 seats
  NUM_SEATS = 6

  def initialize(num_players = NUM_SEATS)
    @blackjacks = []
    @dealer = Dealer.new
    @deck = Deck.new
    @losers = []
    @num_players = num_players.clamp(0, NUM_SEATS)
    @players = []
    @pushes = []
    @winners = []

    @num_players.times do |i|
      @players << Player.new("Player #{i + 1}")
      # assuming "reasonable" players, without even basic card-counting
      @players.last.limit = rand(16..19)
    end
  end

  def play
    puts "Let's play Blackjack!"

    initial_deal

    continue_play unless @dealer.blackjack?

    endgame_scoring
  end

  private

  def initial_deal
    puts
    puts "#{@dealer.name} deals starting hands..."
    puts

    @dealer.deal_starting_hand(@deck, @players)

    ([@dealer] + @players).each_with_index do |p, i|
      printable_showing = p.upcards.map { |c| card_chars(c) }
      printable_showing.unshift('??') if p == @dealer

      puts "#{p.name}: #{printable_showing.join(', ')}"

      if p == @dealer && p.blackjack?
        puts "  flips, revealing Blackjack: #{print_showing(@dealer)}"
      elsif p.blackjack?
        puts "  Blackjack; #{@dealer.blackjack? ? 'push' : 'winner'}"
      end
    end
  end

  def continue_play
    puts
    puts "Play continues..."

    (@players + [@dealer]).each_with_index do |p, i|
      take_turn(p)
    end
  end

  def take_turn(participant)
    puts
    puts "#{participant.name}'s turn:"

    action =
      if participant.respond_to?(:flip)
        participant.flip
        'flips, revealing'
      else
        'showing'
      end

    puts "  #{action} #{print_showing(participant)} (#{participant.score})"

    if participant.blackjack?
      puts "  Blackjack; skipping"
    elsif participant.standing?
      puts "  stands"
    else
      deal_hits_for(participant)
    end
  end

  def deal_hits_for(participant)
    return unless participant.ready?

    card = @deck.draw_card
    puts "  hits on #{participant.score}, receiving #{card_chars(card)}"
    @dealer.hit(participant, card)
    puts "  showing #{print_showing(participant)} (#{participant.score})"

    case
    when participant.busted?   then puts '  busts'
    when participant.standing? then puts '  stands'
    # executive decision: this house won't allow hitting on "soft" 21
    when participant.target?   then puts "  has #{participant.score}"
                               else deal_hits_for(participant)
    end
  end

  def endgame_scoring
    puts
    puts "Round scoring:"

    puts
    puts "#{@dealer.name} showing: #{print_showing(@dealer)}"

    case
    when @dealer.busted? then puts "  busted with #{@dealer.score}"
    when @dealer.blackjack? && @players.filter(&:blackjack?).empty? then puts '  Blackjack'
    when @dealer.blackjack? then puts '  Blackjack; push'
    else puts "  has #{@dealer.score}"
    end

    @players.each_with_index do |p, i|
      puts
      puts "#{p.name} showing: #{print_showing(p)}"

      # TODO: If betting was implemented, this is the part where bets would be
      #       lost and winnings would be paid out.
      case
      when p.busted?
        @losers << p
        puts "  busted with #{p.score}"
        # TODO: @bank.collect(p)
      when @dealer.busted? && p.blackjack?
        @blackjacks << p
        puts "  Blackjack"
        # TODO: @bank.payout(p, 3/2)
      when @dealer.busted?
        @winners << p
        puts "  wins with #{p.score} because #{@dealer.name} busted"
        # TODO: @bank.payout(p, 1)
      when @dealer.blackjack? && p.blackjack?
        @pushes << p
        puts "  matches #{@dealer.name}'s Blackjack; push"
      when @dealer.blackjack?
        @losers << p
        puts "  loses to #{@dealer.name}'s Blackjack"
        # TODO: @bank.collect(p)
      when p.blackjack?
        @blackjacks << p
        puts "  Blackjack"
        # TODO: @bank.payout(p, 3/2)
      when @dealer.score == p.score
        @pushes << p
        puts "  matches #{@dealer.name} with #{p.score}; Push"
      when @dealer.score > p.score
        @losers << p
        puts "  loses with #{p.score} to #{@dealer.name}'s #{@dealer.score}"
        # TODO: @bank.collect(p)
      when @dealer.score < p.score
        @winners << p
        puts "  beats #{@dealer.name}'s #{@dealer.score} with #{p.score}"
        # TODO: @bank.payout(p, 1)
      else
        puts "Edge case discovered!"
        require 'pry-byebug'
        binding.pry
      end
    end

    puts
    puts "Game over. Thanks for playing!"
  end

  def print_showing(participant)
    participant.upcards.map { |c| card_chars(c) }.join(', ')
  end
end
