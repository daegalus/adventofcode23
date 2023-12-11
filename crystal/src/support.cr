class Point
  getter x : Int32, y : Int32

  def initialize(@x, @y)
  end

  def manhattan_distance(other : Point)
    (@x - other.x).abs + (@y - other.y).abs
  end

  def diamond(radius : Int32)
    if radius <= 0
      yield self
    else
      (0...radius).each { |i| yield self + Point.new(i, i - radius) }
      (0...radius).each { |i| yield self + Point.new(radius - i, i) }
      (0...radius).each { |i| yield self + Point.new(-i, radius - i) }
      (0...radius).each { |i| yield self + Point.new(i - radius, -i) }
    end
  end

  def -
    Point.new(-@x, -@y)
  end

  def +(other : Point)
    Point.new(@x + other.x, @y + other.y)
  end

  def +(other : Vector)
    Point.new(@x + other.x, @y + other.y)
  end

  def -(other : Point)
    Vector.new(@x - other.x, @y - other.y)
  end

  def -(other : Point)
    Vector.new(@x - other.x, @y - other.y)
  end

  def ==(other : Point)
    @x == other.x && @y == other.y
  end

  def <(other : Point)
    @y < other.y || (@y == other.y && @x < other.x)
  end

  def <=(other : Point)
    @y < other.y || (@y == other.y && @x <= other.x)
  end

  def >(other : Point)
    @y > other.y || (@y == other.y && @x > other.x)
  end

  def >=(other : Point)
    @y > other.y || (@y == other.y && @x >= other.x)
  end

  def cw : Point
    Point.new(x: -@y, y: @x)
  end

  def ccw : Point
    Point.new(x: @y, y: -@x)
  end

  def hash
    @x.hash ^ @y.hash
  end

  def to_s(io)
    io << "(#{@x}, #{@y})"
  end
end

class Vector
  getter x : Int32, y : Int32

  NORTH = new(+0, -1)
  SOUTH = new(+0, +1)
  WEST  = new(-1, +0)
  EAST  = new(+1, +0)

  FROM_CHAR = {
    'U' => NORTH,
    'D' => SOUTH,
    'L' => WEST,
    'R' => EAST,

    'N' => NORTH,
    'S' => SOUTH,
    'W' => WEST,
    'E' => EAST,
  }

  FROM_STR = {
    "U" => NORTH,
    "D" => SOUTH,
    "L" => WEST,
    "R" => EAST,

    "N" => NORTH,
    "S" => SOUTH,
    "W" => WEST,
    "E" => EAST,
  }

  def initialize(@x, @y)
  end

  def -
    Vector.new(-@x, -@y)
  end

  def +(other : Vector)
    Vector.new(@x + other.x, @y + other.y)
  end

  def +(other : Point)
    Point.new(@x + other.x, @y + other.y)
  end

  def -(other : Vector)
    Vector.new(@x - other.x, @y - other.y)
  end

  def *(other : Vector)
    Vector.new(@x * other.x, @y * other.y)
  end

  def ==(other : Vector)
    @x == other.x && @y == other.y
  end

  def <(other : Vector)
    @y < other.y || (@y == other.y && @x < other.x)
  end

  def <=(other : Vector)
    @y < other.y || (@y == other.y && @x <= other.x)
  end

  def >(other : Vector)
    @y > other.y || (@y == other.y && @x > other.x)
  end

  def >=(other : Vector)
    @y > other.y || (@y == other.y && @x >= other.x)
  end

  def cw : Vector
    Vector.new(x: -@y, y: @x)
  end

  def ccw : Vector
    Vector.new(x: @y, y: -@x)
  end

  def hash
    @x.hash ^ @y.hash
  end

  def to_s(io)
    io << "(#{@x}, #{@y})"
  end

  def to_tuple
    Tuple.new(@x, @y)
  end
end

module Neighborhood(P, V)
  abstract def neighbors(v : P, & : P ->)
  abstract def sphere(v : P, radius : Int, & : P ->)
  abstract def norm(v : V) : Int

  def neighbors(v : P) : Array(P)
    ws = [] of P
    neighbors(v) { |w| ws << w }
    ws
  end

  def sphere(v : P, radius : Int) : Array(P)
    ws = [] of P
    sphere(v, radius) { |w| ws << w }
    ws
  end

  def distance(v : P, w : P) : Int
    norm(v - w)
  end
end

module VonNeumann2D
  extend Neighborhood(Point, Vector)

  def self.neighbors(v : Point, & : Point ->)
    yield v + Vector.new(+0, -1)
    yield v + Vector.new(-1, +0)
    yield v + Vector.new(+1, +0)
    yield v + Vector.new(+0, +1)
  end

  def self.sphere(v : Point, radius : Int, & : Point ->)
    if radius <= 0
      yield v
    else
      (0...radius).each { |i| yield v + Vector.new(i, i - radius) }
      (0...radius).each { |i| yield v + Vector.new(radius - i, i) }
      (0...radius).each { |i| yield v + Vector.new(-i, radius - i) }
      (0...radius).each { |i| yield v + Vector.new(i - radius, -i) }
    end
  end

  def self.norm(v : Vector) : Int
    v.to_tuple.sum(&.abs)
  end
end

module Moore2D
  extend Neighborhood(Point, Vector)

  def self.neighbors(v : Point, & : Point ->)
    yield v + Vector.new(-1, -1)
    yield v + Vector.new(+0, -1)
    yield v + Vector.new(+1, -1)
    yield v + Vector.new(-1, +0)
    yield v + Vector.new(+1, +0)
    yield v + Vector.new(-1, +1)
    yield v + Vector.new(+0, +1)
    yield v + Vector.new(+1, +1)
  end

  def self.sphere(v : Point, radius : Int, & : Point ->)
    if radius <= 0
      yield v
    else
      (-radius...radius).each { |i| yield v + Vector.new(i, -radius) }
      (-radius...radius).each { |i| yield v + Vector.new(radius, -i) }
      (-radius...radius).each { |i| yield v + Vector.new(-i, radius) }
      (-radius...radius).each { |i| yield v + Vector.new(-radius, -i) }
    end
  end

  def self.norm(v : Vector) : Int
    v.to_tuple.max_of(&.abs)
  end
end

class GridBFS(T, N, V)
  @path_proc = Proc(T, V, T, V, Int32, Int32, Bool).new { |src_v, src, dst_v, dst, d_old, d| false }
  @finish_proc = Proc(Hash(T, Int32), Bool).new { |reachable| false }

  def initialize(@grid : Hash(T, V), @neighborhood : N)
  end

  def path(&@path_proc : T, V, T, V, Int32, Int32 -> Bool)
    self
  end

  def finish(&@finish_proc : Hash(T, Int32) -> Bool)
    self
  end

  def run(v0 : T)
    reachable = {v0 => 0}
    frontier = [v0]

    (1..).each do |d|
      new_frontier = [] of Point
      frontier.each do |v1|
        src = @grid[v1]
        @neighborhood.neighbors(v1) do |v2|
          next if reachable.has_key?(v2)
          next unless dst = @grid[v2]?
          next unless @path_proc.call(v1, src, v2, dst, reachable[v1], d)
          reachable[v2] = d
          new_frontier << v2
        end
      end
      frontier.concat(new_frontier).uniq!.reject! do |v1|
        @neighborhood.neighbors(v1).all? { |v2| reachable.has_key?(v2) }
      end
      break d if @finish_proc.call(reachable)
    end
  end
end