#!/usr/bin/env ruby

load 'score-count.rb'
require 'colorize'

class Player

  include SCORECALC

  INITIAL_BALANCE = 100

  def initialize(name, hand)
    @name, @hand, @balance = name, hand, INITIAL_BALANCE
    @score, @rank = get_user_score(@hand)
    @@player_count = (@@player_count + 1) rescue 1
    (@@player_list ||= []) << [@name, @hand]
  end

  attr_reader :name, :hand, :balance, :score, :rank
  attr_accessor :hand, :balance, :score, :rank

  def add_to_hand(card)
    @hand << card
    @score, @rank = get_user_score(@hand)
  end

  def get_cards
    human_readable_hand = []
    suit, value = "", ""
    value_hash = {0 => '2', 1 => '3', 2 => '4', 3 => '5', 4 => '6', 5 => '7', 6 => '8',
                    7 => '9', 8 => '10', 9 => 'J', 10 => 'Q', 11 => 'K', 12 => 'A'}
    #@hand.sort_by { |card| card % 13 }.each do |card|
    @hand.each do |card|
      case card / 13
      when 0
        suit = "♠ (Spades)"
      when 1
        suit = "♥ (Hearts)".red
      when 2
        suit = "♦ (Diamonds)".red
      when 3
        suit = "♣ (Clubs)"
      end
      value = card % 13
      human_readable_hand << "#{value_hash[value]}#{suit}"
    end
    human_readable_hand
  end

  def clear_hand
    @hand = []
  end


  # Class Methods
  def self.player_count
    return @@player_count
  end

  def self.player_list
    return @@player_list
  end

end
