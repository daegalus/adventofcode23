module Advent::Day12

  CACHE = Hash({String, Array(Int32)}, Int64).new

  def self.run
    data = Advent.input(day: 12, title: "Hot Springs")

    answer1, time1 = Advent.time { part1(data) }
    Advent.answer(part: 1, answer: "#{answer1}", time: time1)

    answer2, time2 = Advent.time { part2(data) }
    Advent.answer(part: 2, answer: "#{answer2}", time: time2)
  end

  def self.part1(data)
    data.lines.sum do |line|
      str, ints = line.split(' ', 2)
      calc(str + '.', ints.split(',').map(&.to_i))
    end
  end

  def self.part2(data)
    data.lines.sum do |line|
      str, ints = line.split(' ', 2)
      calc([str].*(5).join('?') + '.', ints.split(',').map(&.to_i) * 5)
    end
  end

  def self.calc(line, ints)
    CACHE.put_if_absent({line, ints}) do
    break 0_i64 if line.count(&.!= '.') < ints.sum
    break line.includes?('#') ? 0_i64 : 1_i64 if ints.empty?

    char = line[0]
    head, *tail = ints

    sum1 = char.in?('.', '?') ? calc(line[1..], ints) : 0_i64
    break sum1 if char == '.' || line[0..head] !~ (/^[?#]+[?.]$/)

    sum1 &+ calc(line[(head + 1)..], tail)
  end
  end
end
