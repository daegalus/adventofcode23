module Advent::Day06
  
  def self.run
    data = Advent.input(day: 6, title: "Wait For It")

    answer1, time1 = Advent.time { part1(data) }
    Advent.answer(part: 1, answer: "#{answer1}", time: time1)

    answer2, time2 = Advent.time { part2(data) }
    Advent.answer(part: 2, answer: "#{answer2}", time: time2)
  end

  def self.part1(data)
    times, distances = data.split('\n').map(&.partition(':')[2].split(' ', remove_empty: true).map(&.to_i64))
    races = times.zip(distances)
    races.product do |t, d|
      lo = ((t - Math.sqrt(t * t - d * 4)) / 2.0).floor.to_i64 + 1
      hi = ((t + Math.sqrt(t * t - d * 4)) / 2.0).ceil.to_i64 - 1
      hi - lo + 1
    end
  end

  def self.part2(data)
    t, d = data.split('\n').map(&.partition(':')[2].gsub(' ', "").to_i64)
    lo = ((t - Math.sqrt(t * t - d * 4)) / 2.0).floor.to_i64 + 1
    hi = ((t + Math.sqrt(t * t - d * 4)) / 2.0).ceil.to_i64 - 1
    hi - lo + 1
  end
end
