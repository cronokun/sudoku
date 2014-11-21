class BaseStrategy
  attr_reader :puzzle

  def self.reduce(puzzle)
    strategy = self.new(puzzle)
    strategy.reduce!
    strategy.reduced?
  end

  def initialize(puzzle)
    @puzzle = puzzle
    @was_reduced = false
  end

  def reduce!
    raise NotImplementedError, "You should define '#reduce!' method in concrete strategy."
  end

  def reduced?
    @was_reduced
  end

  private

  def mark_as_reduced!
    @was_reduced = true
  end
end
