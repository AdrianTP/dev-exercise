class Hand
  attr_reader :cards, :score

  def initialize
    @aces = []
    @cards = []
    @bust = false
    @max_score = 21
    @min_size = 2
    @other_score = 0
    @score = 0
    @soft = false
  end

  def add_card(card)
    @cards << card

    if card.name == :ace
      @aces << card
    else
      @other_score += card.value
    end

    running_total
  end

  def dealt?
    cards.count >= @min_size
  end

  def blackjack?
    target? && cards.count == @min_size
  end

  def bust?
    @bust
  end

  def soft?
    @soft
  end

  def target?
    score == @max_score
  end

  private

  # HACK: This is overly-simplified and assumes knowledge about aces
  def running_total
    aces_lowest_score = @aces.reduce(0) { |sum, ace| sum + ace.value.min }
    ace_low_value = @aces.first&.value&.min || 0
    ace_high_value = @aces.first&.value&.max || 0
    soft_score = @other_score + aces_lowest_score - ace_low_value + ace_high_value
    normal_score = @other_score + @aces.reduce(0) { |sum, ace| sum + ace.value.min }

    if soft_score <= @max_score
      @soft = !@aces.empty?
      @score = soft_score
    elsif normal_score <= @max_score
      @soft = false
      @score = normal_score
    else
      @soft = false
      @bust = true
      @score = normal_score
    end
  end
end
