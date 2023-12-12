module Advent::Day05
  
  def self.run
    data = Advent.input(day: 5, title: "If You Give A Seed A Fertilizer")

    answer1, time1 = Advent.time { part1(data) }
    Advent.answer(part: 1, answer: "#{answer1}", time: time1)

    answer2, time2 = Advent.time { part2(data) }
    Advent.answer(part: 2, answer: "#{answer2}", time: time2)
  end

  def self.part1(data)
    seeds, map_range = parse(data)
    data = seeds.map { |x| {x, x} }
    solve data, map_range
  end

  def self.part2(data)
    seeds, map_range = parse(data)
    data = seeds.each_slice(2).map { |x| {x[0], x[0] + x[1] - 1} }.to_a
    solve data, map_range
  end

  def self.parse(data)
    seeds, *maps_input = data.split("\n\n")
    seeds = seeds.split.tap(&.shift).map(&.to_i64)

    maps_list = [] of Array({Int64, Int64, Int64})
    maps_input.each do |map|
      map_data = map.lines.tap(&.shift).map(&.split.map(&.to_i64))
      maps_list << map_data.map { |a| {a[1], a[1] + a[2] - 1, a[0] - a[1]}}
    end

    {seeds, maps_list}
  end

  def self.solve(init_range, maps_list)
    maps_list.each do |ranges|
      next_range = [] of {Int64, Int64}

      init_range.each do |ia, ib|
        unless found = ranges.find { |ra, rb, _| ia.in?(ra..rb) || ra.in?(ia..ib) }
          next_range << {ia, ib}
          next
        end

        ra, rb, diff = found

        case
        when ia >= ra && ib <= rb
          next_range << {ia + diff, ib + diff}
        when ia < ra && ib > rb
          next_range << {ia, ra - 1}
          next_range << {ra + diff, rb + diff}
          init_range << {rb + 1, ib}
        when ia >= ra && ib > rb
          next_range << {ia + diff, rb + diff}
          init_range << {rb + 1, ib}
        when ia < ra && ib <= rb
          next_range << {ia, ra - 1}
          next_range << {ra + diff, ib + diff}
        end
      end

      init_range = next_range
    end

    init_range.min_of(&.[0])
  end
end
