# Notes

- I changed every single test because the arguments to `assert_equal` were all
  in `actual`, `expected` order, while the order should be `expected`, `actual`.
- I got very deeply sidetracked (on the order of about 5 hours of
  trial-and-error, whiteboarding, research, and frustration) trying to come up
  with a perfectly generic hand value summation algorithm, which would not
  require advance knowledge of which card types had multiple values, how many
  values any given card could have, nor what those values are. Going down rabbit
  holes out of pure curiosity ([FOR](http://dresdencodak.com/2008/05/02/copan/)
  [SCIENCE](http://www.girlgeniusonline.com/comic.php?date=20050527)
  [!](https://www.smbc-comics.com/index.php?db=comics&id=1202)) has been part of
  my personality for my entire life, and is one which I am still struggling to
  curtail. I live for the hunt; the roller coaster of hope and frustration; the
  rush as the fog clears, all the pieces fall into place, and the solution
  finally comes together and it's even more beautiful than you imagined. The
  endorphins are so incredibly addictive.
- When playing with a shoe containing 6 or more full decks of cards, the maximum
  possible hand size (without busting) is 21 cards, as long as every single card
  in the hand are aces.
- When playing with a shoe containing 3 or more full decks of cards, and playing
  at a casino which forbids hitting on a soft 21, the maximum possible hand size
  (without busting) is 11 cards, as long as every single card in the hand are
  aces.
- Interestingly, when playing with a single full deck of cards (as simulated in
  this exercise), the maximum possible hand size (without busting) is _also_ 11
  cards: 4 aces, 4 2s, and 3 3s.

## Order of Play (Simplified)
1. Players "buy in" (place bets).
2. The dealer deals one card face-up to each player in turn, starting with the
   player to the dealer's left
3. The dealer deals one card face-down to themself. This is called the "hole
   card".
4. The dealer deals one additional card face-up to each player in turn, starting
   with the player to the dealer's left.
5. The dealer deals one additional card face-up to themself.
6. If the dealer has 21 ("Blackjack" when only two cards) they immediately
   collect bets from every player whose cards do not also add up to 21, ending
   the round.
7. If any player has 21 ("Blackjack" when only two cards), they immediately win,
   receiving their (typically 3:2) payout and are excluded from the remainder of
   the round. If the dealer also has "Blackjack", this results in a tie (called
   a "push"), and the dealer returns that player's bet.
8. Starting with the player to the dealer's left, each player decides whether to
   "hit" or to "stand".
   a. If this player decides to "hit", the dealer deals them a card from the top
      of the deck.
   b. If this player's hand total goes above 21, they "bust": the dealer
      immediately collects the palyer's bet, and the player is excluded from
      the remainder of the round. Play immediately continues with the next
      player.
   c. If This player's hand total remains below 21, they are then offered the
      same decision to "hit" or to "stand".
   d. If the player decides to "stand", play immediately continues with the next
      player.
   e. If the player's hand total is exactly 21, they must "stand"
9. Once each other player has repeated the same hit/stand/bust/win cycle, the
   dealer flips their "hole card", revealing their full starting hand.
10. The dealer repeats the hit/stand/bust/win cycle with themself, but they are
    typically required to "stand" when their hand total equals 17, unless it's a
    "soft" 17 (one ace in their hand must be valued at 11 for their hand to be
    considered "soft").
11. If the dealer "busts", any remaining players who have not "busted"
    immediately win, receiving their (typically 1:1) payout.
12. Once all players have either stood, busted, or have a hand total of 21,
    scoring begins.

## Scoring
A. If any player's hand total is less than the dealer's hand total, that player
   loses, forfeiting their bet to the dealer.
B. If any player's hand total is more than the dealer's hand total, that player
   wins, collecting a (typically 1:1) payout from the dealer.
C. If any player's hand total is equal to the dealer's hand total, this is a tie
   (called a "push"), and the player simply keeps their bet.

## Suggested Improvements

### Deck class
 - Obviously the implementation would be significantly different if playing
   casino-style with a shoe containing multiple decks and a blank.
 - The current implementation (above) simulates reshuffling all played cards
   between every single round, which is not typical, even for casual home games.

```rb
class Deck
  def initialize
    # I use the built-in `shuffle` method for simplicity, but I woud love to
    # implement an algorithm which emulates a proper shuffling routine with
    # physical cards. I know I had several examples buried in an archive file on
    # an external hard drive, but I cannot locate them at this time.
    @playable_cards = build_deck.shuffle
  end

  def build_deck
    SUITS.each_with_object([]) do |suit, cards|
      NAME_VALUES.each do |name, value|
        cards << Card.new(suit, name, value)
      end
    end
  end

  def deal_card
    # This approach ensures a semi-realistic simulation of a physical deck of
    # cards, with each card coming out in order from top to bottom.
    @playable_cards.shift
  end
end
```
