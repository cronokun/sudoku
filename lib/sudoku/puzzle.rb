class Puzzle
  attr_reader :tiles

  def initialize(data)
    @tiles = build_from_tiles(data)
  end

  def solve!
    Solver.new(self).solve
  end

  def solved?
    tiles.none? &:empty?
  end

  def empty_tiles
    tiles.select &:empty?
  end

  def pretty_print
    tiles.each_slice(9).map do |row|
      row.map(&:to_s).join
    end.join("\n")
  end

  def inspect
    "«Puzzle:\n#{self.pretty_print}»"
  end

  private

  def build_from_tiles(values)
    values.map.with_index do |value, index|
      row = index / 9 + 1
      column = index - (row - 1) * 9 + 1
      value = value == '_' ? nil : value.to_i
      Tile.new(value, row, column)
    end
  end
end
