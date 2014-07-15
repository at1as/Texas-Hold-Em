#!/usr/bin/env ruby

require 'test/unit'
require 'colorize'
load 'score-count.rb'

class Tests < Test::Unit::TestCase

  include SCORECALC

  def initialize; self; end

  def debug_result(hand)
    score, result = get_user_score(hand)
    puts score
  end

  def card_hand_eq(hand, notification)
    score, result = get_user_score(hand)
    assert result.include?(notification), "Fail: #{hand} was ranked #{result} not #{notification}"
  end

  def card_hand_ne(hand, notification)
    score, result = get_user_score(hand)
    assert !result.include?(notification), "Fail (Unexpected): #{hand} was ranked #{result}"
  end

  def hand_random
    hand = (0..51).to_a.sample 7
    puts "Hand... \t\t#{hand}"
    puts "Hand (normalized)... \t#{hand.map {|card| card % 13}}"
    score, result = get_user_score(hand)
  end

  def execute_all
    royal_flush
    straight_flush
    flush
    straight
    four_kind
    three_kind
    two_pair
    pair
    high_card
  end


  def royal_flush(msg = "Royal Flush")
    # Valid Royal Flush
    card_hand_eq([8,9,10,11,12], msg)
    card_hand_eq([21,22,23,24,25], msg)
    card_hand_eq([34,35,36,37,38], msg)
    card_hand_eq([47,48,49,50,51], msg)
    # Not a valid Royal Flush
    card_hand_ne([9,10,11,8,3], msg)
    card_hand_ne([8,9,10,11,13], msg)
    card_hand_ne([9,10,11,12,13], msg)
  end

  def straight_flush(msg = "Straight Flush")
    # Valid Straight Flush
    card_hand_eq([2,3,4,5,6], msg)
    card_hand_eq([1,2,3,4,5,6], msg)
    card_hand_eq([4,5,6,7,8,9], msg)
    # Not a valid Straight Flush
    card_hand_ne([10,11,12,13,14], msg)
    card_hand_ne([9,10,11,12,0], msg)
  end

  def flush(msg="Flush")
    # Valid Flush
    card_hand_eq([1,2,9,7,11], msg)
    card_hand_eq([2,3,4,5,7], msg)
    # Not a valid Flush
    card_hand_ne([9,10,11,12,13], msg)
  end

  def straight(msg="Straight")
    # Valid Flush
    card_hand_eq([43, 0, 11, 3, 40, 28, 6], msg)
    card_hand_eq([43, 0, 11, 3, 40, 28, 6, 18], msg)
  end

  def four_kind(msg="Four of a Kind")
    # Valid Four of a Kind
    card_hand_eq([0,13,26,39,8], msg)
    card_hand_eq([1,14,27,40,8], msg)
    card_hand_eq([2,15,28,41,8], msg)
    card_hand_eq([3,16,29,42,8], msg)
    card_hand_eq([4,17,30,43,8], msg)
    card_hand_eq([5,18,31,44,8], msg)
    card_hand_eq([6,19,32,45,8], msg)
    card_hand_eq([7,20,33,46,8], msg)
    card_hand_eq([8,21,34,47,9], msg)
    card_hand_eq([9,22,35,48,10], msg)
    card_hand_eq([10,23,36,49,11], msg)
    card_hand_eq([11,24,37,50,12], msg)
    card_hand_eq([12,25,38,51,13], msg)
    # Not a valid Four of a Kind
    card_hand_ne([0,13,26,40,41], msg)
  end

  def three_kind(msg="Three of a Kind")
    # Valid Three of a Kind
    card_hand_eq([0,13,26,21,9], msg)
    # Not Valid Three of a Kind
    card_hand_ne([0,13,26,39,8], msg)
    card_hand_ne([1,14,27,40,8], msg)
    card_hand_ne([2,15,28,41,8], msg)
    card_hand_ne([3,16,29,42,8], msg)
    card_hand_ne([4,17,30,43,8], msg)
    card_hand_ne([5,18,31,44,8], msg)
    card_hand_ne([6,19,32,45,8], msg)
    card_hand_ne([7,20,33,46,8], msg)
    card_hand_ne([8,21,34,47,9], msg)
    card_hand_ne([9,22,35,48,10], msg)
    card_hand_ne([10,23,36,49,11], msg)
    card_hand_ne([11,24,37,50,12], msg)
    card_hand_ne([12,25,38,51,13], msg)
  end

  def full_house(msg="Full House")
    # Valid Full House
    card_hand_eq([0,13,26,21,8], msg)
    card_hand_eq([0,13,26,40,41], msg)
    # Not Valid Full House
  end

  def two_pair(msg="Two Pair")
    # Valid Two Pair
    card_hand_eq([0,13,27,40,41], msg)
    card_hand_eq([4, 17, 6, 18, 11, 18, 11], msg) #Three Pairs
    card_hand_eq([0,13,28,6,41], msg)
  end

  def pair(msg="One Pair")
    # Valid Two Pair
    card_hand_eq([0,13,28,6,49], msg)
  end

  def high_card(msg="High Card")
    # Valid High Card
    card_hand_eq([1,2,3,4,51], msg)
  end

end
