require "./support"

module Advent::Day10

  PIPES_OUT = {
    '-' => [Vector::EAST, Vector::WEST],
    '|' => [Vector::SOUTH, Vector::NORTH],
    'L' => [Vector::EAST, Vector::NORTH],
    'J' => [Vector::NORTH, Vector::WEST],
    '7' => [Vector::WEST, Vector::SOUTH],
    'F' => [Vector::SOUTH, Vector::EAST],
    'S' => [Vector::NORTH, Vector::WEST, Vector::SOUTH, Vector::EAST],
    '.' => [] of Vector,
  }

  PIPES_IN = PIPES_OUT.transform_values &.map &.-

  def self.run
    data = Advent.input(day: 10, title: "Pipe Maze")

    answer1, time1 = Advent.time { part1(data) }
    Advent.answer(part: 1, answer: "#{answer1}", time: time1)

    answer2, time2 = Advent.time { part2(data) }
    Advent.answer(part: 2, answer: "#{answer2}", time: time2)
  end

  def self.part1(data)
    grid = data.each_line.with_index.flat_map { |row, y| 
      row.each_char.with_index.map { |ch, x| {Point.new(x, y), ch} } 
    }.to_h
    s = grid.each { |k, v| break k if v == 'S' }.not_nil!
    find_loop(grid, s).size // 2
  end

  def self.part2(data)
    grid = data.each_line.with_index.flat_map { |row, y| 
      row.each_char.with_index.map { |ch, x| {Point.new(x, y), ch} } 
    }.to_h

    s = grid.each { |k, v| break k if v == 'S' }.not_nil!
    loop = find_loop(grid, s)

    width = grid.max_of &.[0].x
    height = grid.max_of &.[0].y
    inside = Array.new(width, Inside::None)
    total = 0

    height.times do |y|
      width.times do |x|
        v = Point.new(x, y)
        if loop.includes?(v)
          inside[x] =
            case {inside[x], grid[v]}
            when {Inside::None, 'F'}  then Inside::Right
            when {Inside::None, '-'}  then Inside::All
            when {Inside::None, '7'}  then Inside::Left
            when {Inside::All, 'F'}   then Inside::Left
            when {Inside::All, '-'}   then Inside::None
            when {Inside::All, '7'}   then Inside::Right
            when {Inside::Right, 'L'} then Inside::None
            when {Inside::Right, 'J'} then Inside::All
            when {Inside::Left, 'J'}  then Inside::None
            when {Inside::Left, 'L'}  then Inside::All
            end || inside[x]
        else
          total += 1 if inside[x] == Inside::All
        end
      end
    end

    total
  end

  def self.find_loop(grid, s)
    v1 = s
    loop = Set{v1}
  
    while true
      v1_pipe = PIPES_OUT[grid[v1]]
      v1 = VonNeumann2D.neighbors(v1) do |v2|
        next if loop.includes?(v2)
        v2_pipe = PIPES_IN[grid[v2]? || next]
        dv = v2 - v1
        break v2 if dv.in?(v1_pipe) && dv.in?(v2_pipe)
      end || break
      loop << v1
    end
  
    grid[s] = PIPES_OUT.each do |ch, outs|
      next if ch == 'S'
      break ch if outs.all? { |v| v.in?(PIPES_IN[grid[s + v]? || next false]) }
    end.not_nil!
  
    loop
  end

  @[Flags]
  enum Inside
    Left
    Right
  end
end
