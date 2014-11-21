class UniqByContainerStrategy
  attr_reader :tiles

  def initialize(tiles)
    @tiles = tiles
    @was_reduced = false
  end

  def reduce!
  end

  def reduced?
    @was_reduced
  end
end
