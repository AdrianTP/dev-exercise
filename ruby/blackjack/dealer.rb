require './player.rb'

class Dealer < Player
  def initialize
    super('Dealer')

    @limit = 17
  end

  def deal_starting_hand(deck, players)
    deal(deck, (players + [self]))
  end

  def flip
    @flipped = true
  end

  def hit(player, card)
    player.receive_card(card)
  end

  def prepare
    super

    @flipped = false
  end

  def receive_card(card)
    super
    flip if blackjack?
  end

  def ready?
    # executive decision: dealer must hit on "soft" 17, e.g. ace and 6 (7 or 17)
    super || (@hand.score == @limit && @hand.soft?)
  end

  def score
    return 0 unless flipped?
    super
  end

  def upcards
    return [] unless dealt?
    return Array(super[1..-1]) unless flipped?
    super
  end

  def flipped?
    @flipped
  end

  private

  def deal(deck, participants)
    participants.map { |p| hit(p, deck.draw_card) }

    participants.filter!(&:waiting?)

    deal(deck, participants) unless participants.empty?
  end
end
