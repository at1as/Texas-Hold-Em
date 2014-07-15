#!/usr/bin/env ruby

require 'test/unit'
load 'Player.rb'
load 'score-count.rb'

class WinnerTest < Test::Unit::TestCase

  def initialize; self; end

  def compare_hands(hand1, hand2, comparison = 1)
    p1 = Player.new(:p1, hand1)
    p2 = Player.new(:p2, hand2)
    p2_score, p2_info = p2.get_user_score(hand2)
    p1_score, p1_info = p1.get_user_score(hand1)

    # spaceship
    puts "Hand 1 #{hand1}"
    puts "Hand 2 #{hand2}"
    puts "p1 hand #{p1.hand}"
    puts "p2 hand #{p2.hand}"
    puts "p1 #{p1}"
    puts "p2 #{p2}"
    puts "P1: #{p1_score}"
    puts "P2: #{p2_score}"
    puts p1_score <=> p2_score
    #<!--spaceship
    result = p1_score <=> p2_score
    puts "Res: #{result}"
    puts "Comp: #{comparison}"
    puts "#{result == comparison}"
    assert_equal(result, comparison)
  end

  def compare_list
    # Third argument = 1 if arg1 > 2, = 0 if arg1 = arg2, = -1 if arg1 < arg2
    #compare_hands([9, 10, 11, 12, 0], [1, 8, 7, 40, 42], 1)
    compare_hands([1, 8, 7, 40, 42], [9, 10, 11, 12, 0], 1)
  end

end
