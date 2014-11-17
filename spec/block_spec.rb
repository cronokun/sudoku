require 'spec_helper'

PUZZLE = <<-STR
5_____17_
____976__
1__5___83
9__72____
_7_6_4_3_
____83__1
68___9__7
__534____
_13_____5
STR

RSpec.describe Block do
  let(:puzzle) { Puzzle.new(parse_puzzle_data(PUZZLE)) }
  let(:block) { Block.new(8, 2, puzzle.tiles) }

  describe "#inspect" do
    it "returns nice inspect string" do
      expect(block.inspect).to eq('«Block 7-1x9-3: 6 8 _ _ _ 5 _ 1 3»')
    end
  end
end
