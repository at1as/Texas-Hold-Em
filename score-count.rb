#!/usr/bin/env ruby

module SCORECALC

  def get_user_score(hand)

    # Hank Ranking (1 - 10) and then applicable points in order
    cards = hand.sort
    cards_suit = cards.map { |card| card / 13 }
    cards_value = cards.map { |card| card % 13 }.sort!
    mag_per_suit = { "0" => [], "1" => [], "2" => [], "3" => [] }
    cards.select { |card| mag_per_suit[(card/13).to_s] << card % 13 }
    mag_per_suit.values.each { |x| x.sort! }
    value_hash = {0 => '2', 1 => '3', 2 => '4', 3 => '5', 4 => '6', 5 => '7', 6 => '8',
                    7 => '9', 8 => '10', 9 => 'J', 10 => 'Q', 11 => 'K', 12 => 'A'}


    #  Flush. Requires 5+ cards of same suit
    if mag_per_suit.values.select { |x| x.length >= 5 }.length > 0
      flush_vals = mag_per_suit.values.select { |x| x.length >= 5 }.sort

      # Royal Flush!
      if ([8, 9, 10, 11, 12] - flush_vals.first).empty?
        score = [10]
        return score, "Royal Flush. High card: A"

      # Straight Flush
      elsif flush_vals.first.select { |card| ([card, card + 1, card + 2, card + 3, card + 4] - flush_vals.first).empty?}.length > 0
        score = [9]
        score << cards_value.select { |card| ([card, card + 1, card + 2, card + 3, card + 4] - cards_value).empty? }.max
        readable_score = score.map { |s| value_hash[s]}
        return score, "Straight Flush. High card: #{readable_score[1]}"

      # Straight Flush (wrap-around)
      elsif ([12, 0, 1, 2, 3] - flush_vals).empty?
        score = [8.5]
        return score, "Straight Flush: A, 2, 3, 4, 5"

      # Vanilla Flush
      else
        score = [6]
        5.times { score << flush_vals.first.pop }
        readable_score = score.map { |s| value_hash[s]}
        return score, "Flush: #{readable_score[1..6]}"
      end


    else
      # Straight. Requires 5+ cards in total
      if hand.length >= 5

        # Straight
        if cards_value.select { |card| ([card, card + 1, card + 2, card + 3, card + 4] - cards_value).empty? }.length > 0
          score = [5]
          score << cards_value.select { |card| ([card, card + 1, card + 2, card + 3, card + 4] - cards_value).empty? }.max
          readable_score = score.map { |s| value_hash[s]}
          return score, "Straight. High card: #{readable_score[1]}"
        # Straight (wrap-around)
        elsif ([12, 0, 1, 2, 3] - cards_value).empty?
          score = [4.5]
          return score, "Straight: A, 2, 3, 4, 5"
        end
      end


      # Four of a Kind
      if cards_value.select { |card| cards_value.count(card) == 4 }.length > 0
        score = [8]
        mag = cards_value.select { |card| cards_value.count(card) == 4 }
        score << mag.first
        cards_value.delete(mag.first)
        score << cards_value.sort!.pop
        readable_score = score.map { |s| value_hash[s]}
        return score, "Four of a Kind: [#{readable_score[1]}] with Kicker: #{readable_score[2]}"


      # Three of a Kind or Full House
      elsif cards_value.select { |card| cards_value.count(card) == 3 }.length > 0

        # Full House
        if cards_value.select { |card| cards_value.count(card) == 2 }.length > 0
          score = [7]
          score << cards_value.select { |card| cards_value.count(card) == 3 }.max
          cards_value.delete(score[1])
          score << cards_value.select { |card| cards_value.count(card) >= 2 }.max
          readable_score = score.map { |s| value_hash[s]}
          return score, "Full House: Three #{readable_score[1]}'s with Two #{readable_score[2]}'s"

        # Three of a Kind
        else
          score = [4]
          mag = cards_value.select { |card| cards_value.count(card) == 3 }
          score << mag.max
          cards_value.delete(mag.max)
          2.times { score << cards_value.sort!.pop }
          readable_score = score.map { |s| value_hash[s]}
          return score.compact, "Three of a Kind: [#{readable_score[1]}] with Kickers: #{readable_score[2..3]}"
        end


      # Two Pair
      elsif cards_value.select { |card| cards_value.count(card) == 2 }.uniq.length >= 2
        score = [3]
        mag = cards_value.select { |card| cards_value.count(card) == 2}.uniq.sort.reverse
        score += mag[0,2]
        mag.each { |pair| cards_value.delete(pair) }
        score << cards_value.pop
        readable_score = score.map { |s| value_hash[s]}
        return score.compact, "Two Pair: #{readable_score[1..2]} with Kicker: #{readable_score[3]}"


      # One Pair
      elsif cards_value.uniq.length + 1 == cards_value.length
        score = [2]
        mag = cards_value.select { |card| cards_value.count(card) == 2 }.max
        score << mag
        cards_value.delete(mag)
        3.times { score << cards_value.pop }
        readable_score = score.map { |s| value_hash[s]}
        if hand.length == 2
          return score.compact, "One Pair: [#{readable_score[1]}]"
        else
          return score.compact, "One Pair: [#{readable_score[1]}] with Kickers: #{readable_score[2..-1].compact}"
        end


      # High Card
      else
        score = [1]
        5.times { score << cards_value.pop }
        readable_score = score.map { |s| value_hash[s]}
        return score.compact, "High Card [#{readable_score[1]}] with Kickers: #{readable_score[2..-1].compact}"
      end

    end
  end
end
