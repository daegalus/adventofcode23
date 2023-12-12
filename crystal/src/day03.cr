module Advent::Day03
  def self.run
    data = Advent.input(day: 3, title: "Gear Ratios")
    grid = data.lines.map(&.chars)

    answer1, time1 = Advent.time do
      symbols = Set({Int32, Int32}).new
      grid.each_with_index do |row, y|
        row.each_with_index do |ch, x|
          if ch != '.' && !ch.in?('0'..'9')
            (-1..1).each { |dy| (-1..1).each { |dx| symbols << {x + dx, y + dy} } }
          end
        end
      end

      sum = 0
      grid.each_with_index do |row, y|
        row.join.scan(/\d+/) do |m|
          if (m.begin...m.end).any? { |x| symbols.includes?({x, y}) }
            sum += m[0].to_i
          end
        end
      end

      sum
    end
    Advent.answer(part: 1, answer: "#{answer1}", time: time1)

    answer2, time2 = Advent.time do
      gears = Hash({Int32, Int32}, Array(Int32)).new
      grid.each_with_index do |row, y|
        row.each_with_index do |ch, x|
          if ch == '*'
            gears[{x, y}] = [] of Int32
          end
        end
      end

      grid.each_with_index do |row, y|
        row.join.scan(/\d+/) do |m|
          ->do
            (m.begin...m.end).each do |x|
              (-1..1).each do |dy|
                (-1..1).each do |dx|
                  if g = gears[{x + dx, y + dy}]?
                    g << m[0].to_i
                    return
                  end
                end
              end
            end
          end.call
        end
      end

      gears.sum { |_, v| v.size == 2 ? v.product : 0 }
    end
    Advent.answer(part: 2, answer: "#{answer2}", time: time2)
  end
end
