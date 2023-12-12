module Advent::Day09

  def self.run
    data = Advent.input(day: 9, title: "Mirage Maintenance")

    answer1, time1 = Advent.time { part1(data) }
    Advent.answer(part: 1, answer: "#{answer1}", time: time1)

    answer2, time2 = Advent.time { part2(data) }
    Advent.answer(part: 2, answer: "#{answer2}", time: time2)
  end

  def self.part1(data)
    data.each_line.sum do |line|
      values = [line.split(' ').map(&.to_i)]
      until values.last.all?(&.zero?)
        values << values.last.each_cons_pair.map { |a, b| b - a }.to_a
      end
      values.sum(&.last)
    end
  end

  def self.part2(data)
    data.each_line.sum do |line|
      values = [line.split(' ').map(&.to_i)]
      until values.last.all?(&.zero?)
        values << values.last.each_cons_pair.map { |a, b| b - a }.to_a
      end
      values.each_with_index.sum { |row, i| row.first * (i.odd? ? -1 : 1) }
    end
  end
end
