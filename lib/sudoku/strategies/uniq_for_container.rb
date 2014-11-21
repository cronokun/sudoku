# Fill tiles with unique suggestion per row/column/block.
#
# If a row has 3 empty tiles with given suggestions: [1,2], [1,2,3], [1,2],
# it's obvious that second tile should be filled with 3.

# TODO allow any container: row, column or block (if we really need it).
class UniqForContainerStrategy < BaseStrategy
  def reduce!
    reducible_containers.each do |empty_tiles|
      suggestions_per_container = get_suggestions_for(empty_tiles)

      empty_tiles.each do |tile|
        reduce_tile(tile, suggestions_per_container)
      end
    end
  end

  private

  def reducible_containers(container = :row)
    puzzle.empty_tiles.group_by(&container).values
  end

  def reduce_tile(tile, suggestions_per_container)
    if value = get_uniq_value(tile, suggestions_per_container)
      tile.value = value and mark_as_reduced!
    end
  end

  def get_uniq_value(tile, suggestions)
    tile.suggestions.find { |value| suggestions.count(value) == 1}
  end

  def get_suggestions_for(tiles_in_container)
    tiles_in_container.flat_map &:suggestions
  end
end
