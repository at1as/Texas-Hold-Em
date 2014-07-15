Texas-Hold-Em
=============

A simple Texas Hold 'Em game for the terminal. Written in Ruby.

### Gameplay
<pre>
 --------------------------------------
|  Balance: 60   ||   Current Bet: 0   |
 --------------------------------------

> Hand:
	 2♣ (Clubs)
	 Q♠ (Spades)
	 4♣ (Clubs)
	 10♠ (Spades)
	 10♣ (Clubs)
	 K♣ (Clubs)
	 A♠ (Spades)

> Rank: 
	One Pair: [10] with Kickers: ["A", "K", "Q"] 

> Opponent Rank: 
	Two Pair: ["K", "10"] with Kicker: A 

> Opponent Hand:
	 7♥ (Hearts)
	 K♥ (Hearts)
	 4♣ (Clubs)
	 10♠ (Spades)
	 10♣ (Clubs)
	 K♣ (Clubs)
	 A♠ (Spades)

Opponent wins
Press any key to continue...
</pre>


### Run

- Clone repository
- Assign execute permissions
- ./holdem.rb

### Configuration

See holdem-conf.yaml to configure the following settings:

- Whether opponent hands are shown at the end of the round
- Whether the opponenet starts with the same cash on hand as you,or otherwise are assigned an unlimited pot
