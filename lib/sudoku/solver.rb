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
    was_reduced = UniqByTileStrategy.reduce(puzzle)

    unless was_reduced
      was_reduced = fill_uniq_tiles!(:row)
    end

    unless was_reduced
      was_reduced = fill_uniq_tiles!(:column)
    end

    unless was_reduced
      dump!
      raise CanNotSolveError, "Can't solve puzzle"
    end
  end

  def fill_uniq_tiles!(param)
    was_reduced = false

    puzzle.empty_tiles.group_by(&param).each do |_, tiles_in_container|
      tiles_in_container.each do |tile|
        result = check_uniq_value(tile, tiles_in_container)

        if result
          tile.value = result
          tile.suggestions = []
          was_reduced = true
        end
      end
    end

    was_reduced
  end

  def check_uniq_value(tile, all_tiles)
    suggestions_for_row = all_tiles.flat_map &:suggestions
    tile.suggestions.find { |value| suggestions_for_row.count(value) == 1}.tap do |r|
      debug %Q(From tiles:\n#{ all_tiles.map(&:inspect).join("\n") }),
           "got #{r || '_'} for #{tile.inspect}", nil if r
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
