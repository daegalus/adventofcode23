module Advent::Day01
  NUMS = {
    "one"   => 1,
    "two"   => 2,
    "three" => 3,
    "four"  => 4,
    "five"  => 5,
    "six"   => 6,
    "seven" => 7,
    "eight" => 8,
    "nine"  => 9,
    "1"     => 1,
    "2"     => 2,
    "3"     => 3,
    "4"     => 4,
    "5"     => 5,
    "6"     => 6,
    "7"     => 7,
    "8"     => 8,
    "9"     => 9,
  }

  def self.run
    data = Advent.input(day: 1, title: "Trebuchet?!")

    answer1 = data.each_line.sum { |str|
      digits = str.scan(/\d/)
      digits[0][0].to_i * 10 + digits[-1][0].to_i
    }
    Advent.answer(part: 1, answer: "#{answer1}")

    answer2 = data.each_line.sum { |str|
      digit1 = str.match!(/(#{NUMS.keys.join('|')})/)[1]
      digit2 = str.match!(/.*(#{NUMS.keys.join('|')})/)[1]
      NUMS[digit1] * 10 + NUMS[digit2]
    }
    Advent.answer(part: 2, answer: "#{answer2}")
  end
end
