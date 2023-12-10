module Advent::Day08

  def self.run
    data = Advent.input(day: 8, title: "Haunted Wasteland")

    answer1 = part1(data)
    Advent.answer(part: 1, answer: "#{answer1}")

    answer2 = part2(data)
    Advent.answer(part: 2, answer: "#{answer2}")
  end

  def self.part1(data)
    path, _, network = data.partition("\n\n")
    network = network.lines.to_h do |line|
      from, _, to = line.partition " = "
      l, _, r = to.lchop('(').rchop(')').partition(", ")
      {from, {l, r}}
    end
    at = "AAA"
    path = path.each_char.cycle
    (1..).each do |i|
      at = network[at][path.next == 'R' ? 1 : 0]
      break i if at == "ZZZ"
    end
  end

  def self.part2(data)
    path, _, network = data.partition("\n\n")
    network = network.lines.to_h do |line|
      from, _, to = line.partition " = "
      l, _, r = to.lchop('(').rchop(')').partition(", ")
      {from, {l, r}}
    end
    path = path.chars

    all_steps = network.keys.select(&.ends_with?('Z')).map do |z|
      at = network.keys.select &.ends_with?('A')
      (0_i64..).each do |i|
        r = path[i % path.size] == 'R' ? 1 : 0
        at.map! { |v| network[v][r] }
        break i + 1 if at.includes?(z)
      end
    end

    all_steps.reduce { |x, y| x.lcm(y) }
  end
end
