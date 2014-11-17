class Solver
  attr_reader :puzzle

  def initialize(puzzle)
    @puzzle = puzzle
  end

  def solve
    reduce_puzzle until puzzle.solved?
    puzzle
  end

  private

  def reduce_puzzle
    was_reduced = false

    fill_suggestions!

    puzzle.empty_tiles.each do |tile|
      if tile.reducible?
        tile.reduce
        was_reduced = true
      end
    end

    unless was_reduced
      dump!
      fail "Can't solve puzzle"
    end
  end


  def fill_suggestions!
    puzzle.empty_tiles.each do |tile|
      tile.suggestions = get_suggestions_for_tile(tile)
    end
  end

  def get_suggestions_for_tile(tile)
    # TODO
    by_block = get_suggestions(Block, tile)
    by_column = get_suggestions(Column, tile)
    by_row = get_suggestions(Row, tile)

    (1..9).to_a - (by_block | by_column | by_row)
  end

  def get_suggestions(container, tile)
    container.new(tile.row, tile.column, puzzle.tiles).values
  end


  # DEBUG

  def dump!
    puts 'Debug data:'
    puts puzzle.pretty_print, nil
    puts puzzle.empty_tiles.map(&:inspect).join("\n")
  end

  def debug(string)
    puts string if debug_mode?
  end

  def debug_mode?
    ARGV.include? '--debug'
  end
end
