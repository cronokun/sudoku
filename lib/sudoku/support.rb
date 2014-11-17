Block = Struct.new(:row, :column, :grid) do
  def tiles
    rows, columns = get_block_range(row), get_block_range(column)

    @tiles ||= grid.select do |tile|
      rows.include?(tile.row) && columns.include?(tile.column)
    end
  end

  def values
    tiles.map &:value
  end

  def inspect
    "«Block #{tiles.first.row}-#{tiles.first.column}x" <<
    "#{tiles.last.row}-#{tiles.last.column}: " <<
    "#{ tiles.map(&:to_s).join(' ') }»"
  end

  def get_block_range(tile)
    [1..3, 4..6, 7..9].find { |range| range.include?(tile) }.to_a
  end
end

Column = Struct.new(:row, :column, :grid) do
  def tiles
    @tiles ||= grid.select { |tile| tile.column == column }
  end

  def values
    tiles.map &:value
  end

  def to_s
    tiles.map(&:to_s).join(' ')
  end

  def inspect
    "«Column ##{column}: #{self.to_s}»"
  end
end

Row = Struct.new(:row, :column, :grid) do
  def tiles
    @tiles ||= grid.select { |tile| tile.row == row }
  end

  def values
    tiles.map &:value
  end

  def to_s
    tiles.map(&:to_s).join(' ')
  end

  def inspect
    "«Row ##{row}: #{self.to_s}»"
  end
end

Tile = Struct.new(:value, :row, :column) do
  attr_accessor :suggestions

  def empty?
    value.nil?
  end

  def reducible?
    suggestions && suggestions.size == 1
  end

  def reduce
    self.value = suggestions.first if reducible?
  end

  def to_s(empty_char = '_')
    value || empty_char
  end

  def inspect
    if suggestions
      "«Tile: '#{self.to_s}', #{row}x#{column} #{suggestions.inspect}»"
    else
      "«Tile: '#{self.to_s}', #{row}x#{column}»"
    end
  end
end
