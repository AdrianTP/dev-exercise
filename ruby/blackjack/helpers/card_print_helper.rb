module CardPrintHelper
  NAME_CHARS = {
    :two   => '2',
    :three => '3',
    :four  => '4',
    :five  => '5',
    :six   => '6',
    :seven => '7',
    :eight => '8',
    :nine  => '9',
    :ten   => '10',
    :jack  => 'J',
    :queen => 'Q',
    :king  => 'K',
    :ace   => 'A'
  }

  SUIT_CHARS = {
    :clubs    => '♣',
    :diamonds => '♦',
    :hearts   => '♥',
    :spades   => '♠'
  }

  def card_chars(card)
    name_char = NAME_CHARS[card.name]
    suit_char = SUIT_CHARS[card.suit]

    "#{name_char}#{suit_char}"
  end
end
