# Get suggestions for each tile; if only single suggestion available,
# file a tile with it. Suggestions calculated by sum of available
# values for row, column and block for the given tile.

class UniqByTileStrategy < BaseStrategy
  def reduce!
    puzzle.empty_tiles.each { |tile| fill_suggestions(tile) }
  end

  private

  def fill_suggestions(tile)
    get_suggestions_for_tile(tile).tap do |suggestions|
      if suggestions.length == 1
        tile.value = suggestions.first
        tile.suggestions = [] # XXX is it necessary?
        mark_as_reduced!
      else
        tile.suggestions = suggestions
      end
    end
  end

  def get_suggestions_for_tile(tile)
    # TODO optimization: early return if single suggestion
    by_block = get_suggestions(Block, tile)
    by_column = get_suggestions(Column, tile)
    by_row = get_suggestions(Row, tile)
    (1..9).to_a - (by_block | by_column | by_row)
  end

  def get_suggestions(container, tile)
    container.new(tile.row, tile.column, puzzle.tiles).values
  end
end
