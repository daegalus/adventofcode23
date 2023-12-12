module Advent::Day07
  
  CARDS = "23456789TJQKA"
  CARDS2 = "J23456789TQKA"

  def self.run
    data = Advent.input(day: 7, title: "Camel Cards")

    answer1, time1 = Advent.time { part1(data) }
    Advent.answer(part: 1, answer: "#{answer1}", time: time1)

    answer2, time2 = Advent.time { part2(data) }
    Advent.answer(part: 2, answer: "#{answer2}", time: time2)
  end

  def self.part1(data)
    hands = data.lines.map do |line|
      cards, _, bid = line.partition(' ')
      {cards.chars, bid.to_i}
    end
    hands.sort_by! do |cards, _|
      {cards.tally.values.sort!.reverse!, cards.map { |c| CARDS.index!(c) }}
    end
    hands.each_with_index.sum { |(_, bid), i| bid * (i + 1) }
  end

  def self.part2(data)
    hands = data.lines.map do |line|
      cards, _, bid = line.partition(' ')
      {cards.chars, bid.to_i}
    end
    hands.sort_by! do |cards, _|
      best = cards.uniq.max_of do |j|
        cards.map { |v| v == 'J' ? j : v }.tally.values.sort!.reverse!
      end
      {best, cards.map { |c| CARDS2.index!(c) }}
    end
    hands.each_with_index.sum { |(_, bid), i| bid * (i + 1) }
  end
end
