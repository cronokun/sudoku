class PuzzleParser
  def self.parse_and_build(file)
    # TODO: lazy refactoring
    new(file).parse.build_puzzles
  end

  def initialize(file)
    @file = file
    @data = []
  end

  def parse(separator = '\=')
    @data = IO.read(@file).split(%r{^#{separator}+$}).map do |data|
      data.gsub("\n", '').chars
    end

    self
  end

  def build_puzzles(data = @data)
    data.map { |puzzle_data| Puzzle.new(puzzle_data) }
  end
end
