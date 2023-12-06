module Advent::Day04
  
  def self.run
    data = Advent.input(day: 4, title: "Scratchcards")

    answer1 = data.each_line.sum do |line|
      winning, nums = parse_winning line
      1 << (winning.count(&.in?(nums)) - 1)
    end

    Advent.answer(part: 1, answer: "#{answer1}")

    input = data.lines
    counts = Array.new(input.size, 1)
    input.each_with_index do |line, i|
      winning, nums = parse_winning line
      winning.count(&.in?(nums)).times do |j|
        counts[i + j + 1] += counts[i]
      end
    end

    answer2 = counts.sum
    Advent.answer(part: 2, answer: "#{answer2}")
  end

  def self.parse_winning(line)
    _, _, line = line.partition(": ")
    winning, _, nums = line.partition(" | ")
    winning = winning.split(' ', remove_empty: true)
    nums = nums.split(' ', remove_empty: true)
    {winning, nums}
  end
end
