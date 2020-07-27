require './hand.rb'

class Player
  attr_reader :hand, :name

  attr_writer :limit

  def initialize(name = nil)
    @name = name || "Player #{unique_name}"
    @limit = 21
    prepare
  end

  def prepare
    @score = 0

    @hand = Hand.new
  end

  def receive_card(card)
    @hand.add_card(card)
  end

  def score
    @hand.score
  end

  def upcards
    @hand.cards
  end

  def blackjack?
    @hand.blackjack?
  end

  def busted?
    @hand.bust?
  end

  def dealt?
    @hand.dealt?
  end

  def ready?
    # executive decision: this house won't allow hitting on a "soft 21"
    @hand.score < @limit
  end

  def standing?
    !ready?
  end

  def target?
    @hand.target?
  end

  def waiting?
    !dealt?
  end

  private

  def unique_name
    # borrowed from https://gist.github.com/DarrenN/1380593#gistcomment-2636595
    sprintf("%20.10f", Time.now.to_f).delete('.').to_i.to_s(36)
  end
end
