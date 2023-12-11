require "./support"
require "bit_array"

module Advent::Day11

  def self.run
    data = Advent.input(day: 11, title: "Pipe Maze")

    answer1 = part1(data)
    Advent.answer(part: 1, answer: "#{answer1}")

    answer2 = part2(data)
    Advent.answer(part: 2, answer: "#{answer2}")
  end

  def self.part1(data)
    calc(data, 1)
  end

  def self.part2(data)
    calc(data, 999999)
  end

  def self.calc(data, expansion)
    map = data.each_line.map(&.chars).to_a
    expand_x = BitArray.new(map[0].size) { |x| map.all? &.[x].== '.' }
    expand_y = BitArray.new(map.size) { |y| map[y].all? &.== '.' }
  
    galaxies = [] of Point
    map.each_with_index do |line, y|
      line.each_with_index do |ch, x|
        galaxies << Point.new(x, y) if ch == '#'
      end
    end
  
    galaxies.each_combination(2).sum do |(a, b)|
      VonNeumann2D.distance(a, b).to_i64 + expansion * (
        a.x.to(b.x).count { |x| expand_x[x] } +
        a.y.to(b.y).count { |y| expand_y[y] })
    end
  end
end
