class Parser
  def self.parse(file)
    IO.read(file).split(/^\=+$/).map do |puzzle|
      puzzle.gsub("\n", '').chars
    end
  end

  def self.to_file(puzzle)
    puzzle.tiles.each_slice(9).map do |row|
      row.map(&:value).join
    end.join("\n")
  end
end

class Puzzle
  attr_reader :tiles

  def initialize(tiles)
    @tiles = build_puzzle(tiles)
  end

  def solve!
    PuzzleSolver.new(self).solve
    self
  end

  def to_s
    tiles.each_slice(9).map do |row|
      row.map { |t| t.value || '_' }.join(' ')
    end.join("\n")
  end

  private

  def build_puzzle(values)
    values.map.with_index do |value, index|
      row = index / 9 + 1
      col = index - (row - 1) * 9 + 1
      value = value == '_' ? nil : value.to_i
      Tile.new(value, row, col)
    end
  end
end

class PuzzleSolver
  attr_reader :puzzle, :tiles

  def initialize(puzzle)
    @puzzle = puzzle
    @tiles = puzzle.tiles
    @debug = ARGV[1]
  end

  def solve
    step = 0

    until solved?
      step += 1
      puts nil, "Step ##{step}", puzzle.to_s, nil if @debug

      fill_suggestions!

      puts tiles_with_single_suggestion.map { |t| "#{t.to_s} : #{t.suggestions.inspect}" } if @debug

      tiles_with_single_suggestion.each do |tile|
        tile.value = tile.suggestions.first
        tile.suggestions = []
        puts "Filling r:#{tile.row}-c:#{tile.column} with #{tile.value}" if @debug
      end

      puts tiles_by_number_of_suggestions.map { |t| "#{t.to_s} : #{t.suggestions.inspect}" } if @debug
    end

    puts nil, "~~~~ Solved! ~~~~", nil, puzzle.to_s if @debug
  end

  def solved?
    tiles.all? &:value
  end

  private

  def fill_suggestions!
    unfiled_tiles.each do |tile|
      tile.suggestions = get_suggestions(tile)
    end
  end

  def unfiled_tiles
    tiles.select { |tile| tile.value.nil? }
  end

  def get_suggestions(tile)
    filled = Row.new(tile, tiles).values |
             Column.new(tile, tiles).values |
             Block.new(tile, tiles).values

    (1..9).to_a - filled
  end

  def tiles_with_single_suggestion
    tiles.select do |tile|
      tile.suggestions.length == 1
    end
  end

  def tiles_by_number_of_suggestions
    tiles.reject do |tile|
      tile.suggestions.empty?
    end.sort { |tile, other| tile.suggestions.length <=> other.suggestions.length }
  end
end

Tile = Struct.new(:value, :row, :column) do
  attr_accessor :suggestions

  def initialize(value, row, column)
    super
    @suggestions = []
  end

  def to_s(empty_str = '_')
    "#{value || empty_str} (r:#{row} x c:#{column})"
  end
end

Row = Struct.new(:tile, :grid) do
  def tiles
    grid.select { |t| t.row == tile.row }
  end

  def values
    tiles.map(&:value).compact
  end

  def to_s
    "Row:\n#{tiles.map(&:to_s)}"
  end
end

Column = Struct.new(:tile, :grid) do
  def tiles
    grid.select { |t| t.column == tile.column }
  end

  def values
    tiles.map(&:value).compact
  end

  def to_s
    "Column:\n#{tiles.map(&:to_s)}"
  end
end

Block = Struct.new(:tile, :grid) do
  def tiles
    col_range = get_block_range(tile.column)
    row_range = get_block_range(tile.row)
    grid.select { |t| row_range.include?(t.row) && col_range.include?(t.column) }
  end

  def values
    tiles.map(&:value).compact
  end

  def get_block_range(tile)
    [1..3, 4..6, 7..9].find { |range| range.include?(tile) }.to_a
  end

  def to_s
    "Block:\n#{tiles.map(&:to_s)}"
  end
end


# Solve ALL puzzles!!!
result = Parser.parse(ARGV[0]).map do |puzzle_data|
  result = Puzzle.new(puzzle_data).solve!
  puts Parser.to_file(result), "#{'=' * 9}\n"
end
