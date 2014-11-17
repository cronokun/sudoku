module Helpers
  def parse_puzzle_data(data)
    data.delete("\n").chars
  end
end
