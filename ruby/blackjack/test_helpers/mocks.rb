require './card.rb'
require './deck.rb'

module Mocks
  class MockableDeck < Deck
    attr_reader :playable_cards

    def draw_card
      @playable_cards.shift
    end

    def stack(cards)
      @playable_cards = cards
    end
  end

  def inject_card_mocks
    @two ||= Card.new(nil, :two, 2)
    @three ||= Card.new(nil, :three, 3)
    @four ||= Card.new(nil, :four, 4)
    @five ||= Card.new(nil, :five, 5)
    @six ||= Card.new(nil, :six, 6)
    @seven ||= Card.new(nil, :seven, 7)
    @eight ||= Card.new(nil, :eight, 8)
    @nine ||= Card.new(nil, :nine, 9)
    @ten ||= Card.new(nil, :ten, 10)
    @jack ||= Card.new(nil, :jack, 10)
    @queen ||= Card.new(nil, :queen, 10)
    @king ||= Card.new(nil, :king, 10)
    @ace ||= Card.new(nil, :ace, [1, 11])
  end

  def inject_mockable_deck
    @deck ||= MockableDeck.new
  end
end
