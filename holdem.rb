#!/usr/bin/env ruby

load 'Player.rb'
require 'colorize'
require 'yaml'

@cards, @bet = [], 0

# Create players
@players = Array.new(2)
@players[0] = Player.new(:user, [])
@players[1] = Player.new(:opponent, [])


# Populate Deck with all cards
def shuffle
  52.times { |card| @cards << card }

  # Shuffle Deck between 2 and 5 times (randomly chosen)
  shuffle_count = 2 + Random.rand(3)
  shuffle_count.times { @cards.shuffle! }
end


# Configure settings specified in holdem-conf.yaml
def configure
  settings = YAML::load_file('holdem-conf.yaml')
  if settings["opponent-unlimited-funds"]
    @players[1].balance = 1.0/0.0
  end
  if settings["show-opponent-hand"]
    @show_opponent_hand = true
  end
end


def place_bet(current_bet)
  unless current_bet.nil? or current_bet < 0
    if @players.all? { |player| player.balance >= current_bet.to_i }
      @players[0].balance -= current_bet
      @players[1].balance -= current_bet
      @bet = current_bet.to_i
    else
      puts "Bet must be valid integer and cannot exceed #{[@players[0].balance, @players[1].balance].min}"
    end
  end
end


# Determine which player has the higher score
def find_winner
  winner = @players[0].score <=> @players[1].score
  if winner == 1
    @players[0].balance += 2*@bet
    puts "#{@players[0].score} /n #{@players[1].score}"
    puts "\nYou win!".red
  elsif winner == -1
    @players[1].balance += 2*@bet
    puts "\nOpponent wins".red
  else
    puts "\nA tie".red
    @players[0].balance += @bet
    @players[1].balance += @bet
  end
end


# Main method. Continuously looping while game is being played
def game_play
  while true
    shuffle

    # Pre-flop (user's initial two cards)
    2.times { @players[0].add_to_hand(@cards.pop) }
    2.times { @players[1].add_to_hand(@cards.pop) }
    print_info
    puts "\n> Enter Bet amount. (0 for no bet): \n\t"
    bet_amount = Integer(gets) rescue nil
    place_bet(bet_amount)

    # Flop (the next three cards, overturned)
    flop = []
    3.times { flop << @cards.pop }
    flop.each { |c| @players[0].add_to_hand(c); @players[1].add_to_hand(c) }
    print_info
    unless @players[0].balance == 0 then puts "\n> Raise Bet amount? (0 for no raise): \n\t" end
    bet_amount = Integer(gets) rescue nil
    place_bet(bet_amount)

    # Turn (the next card, overturned)
    turn = @cards.pop
    @players[0].add_to_hand(turn)
    @players[1].add_to_hand(turn)
    print_info
    unless @players[0].balance == 0 then puts "\n> Raise Bet amount? (0 for no raise): \n\t" end
    bet_amount = Integer(gets) rescue nil
    place_bet(bet_amount)

    # River (the next card, overturned)
    river = @cards.pop
    @players[0].add_to_hand(river)
    @players[1].add_to_hand(river)
    print_info
    if @show_opponent_hand
      puts "\n> Opponent Rank: \n\t#{@players[1].rank} \n"
      puts "\n> Opponent Hand:"
      @players[1].get_cards.each { |card| puts "\t #{card}"}
    end
    find_winner

    # Clear hands for next shuffle
    puts "Press any key to continue..."; gets
    @bet = 0
    @players[0].clear_hand
    @players[1].clear_hand

    # Check that all players are still in the game
    if @players[0].balance <= 0
      puts "You're out of funds. You lose".red
      break
    elsif @players[1].balance <= 0
      puts "You're opponent is out of funds. You win the tournament!".red
      break
    end

  end
end

def print_info
  system "clear" or system "cls"
  length = "|  Balance: #{@players[0].balance}   ||   Current Bet: #{@bet}   |".length - 2
  puts " " + "-"*length
  puts "|  Balance: #{@players[0].balance}   ||   Current Bet: #{@bet}   |"
  puts " " + "-"*length
  puts "\n> Hand:"
  @players[0].get_cards.each { |card| puts "\t #{card}"}
  puts "\n> Rank: \n\t#{@players[0].rank} \n"
end

configure
game_play
