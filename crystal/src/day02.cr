module Advent::Day02
  TOTALS = {"red" => 12, "green" => 13, "blue" => 14}

  def self.run
    data = Advent.input(day: 2, title: "Cube Conundrum")

    answer1 = data.each_line
      .sum do |line|
        game, _, records = line.partition(": ")
        id = game.lchop("Game ").to_i
        records = records.split("; ").map(&.split(", ").map(&.partition(' ')))
        records.all?(&.all? { |count, _, color| count.to_i <= TOTALS[color] }) ? id.to_i : 0
      end
    Advent.answer(part: 1, answer: "#{answer1}")

    answer2 = data.each_line
      .sum do |line|
        game, _, records = line.partition(": ")
        id = game.lchop("Game ").to_i
        records = records.split("; ").map(&.split(", ").map(&.partition(' ')))
        {"red", "green", "blue"}.product do |color|
          records.max_of { |v| v.find(&.[2].== color).try(&.[0].to_i) || 0 }
        end
      end
    Advent.answer(part: 2, answer: "#{answer2}")
  end
end
