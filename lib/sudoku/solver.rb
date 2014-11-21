class Solver
  CanNotSolveError = Class.new(StandardError)

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
    was_reduced = UniqByTileStrategy.reduce(puzzle) ||
                  UniqForContainerStrategy.reduce(puzzle)

    unless was_reduced
      dump!
      raise CanNotSolveError, "Can't solve puzzle"
    end
  end

  # DEBUG

  def dump!
    return unless debug_mode?
    puts 'Debug data:'
    puts puzzle.pretty_print, nil
    puts puzzle.empty_tiles.map(&:inspect).join("\n")
  end

  def debug(*lines)
    puts lines.join("\n") if debug_mode?
  end

  def debug_mode?
    ARGV.include? '--debug'
  end
end
