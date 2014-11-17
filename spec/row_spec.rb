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

RSpec.describe Row do
  let(:puzzle) { Puzzle.new(parse_puzzle_data(PUZZLE)) }
  let(:row) { Row.new(4, 5, puzzle.tiles) }

  describe "#inspect" do
    it "returns nice inspect string" do
      expect(row.inspect).to eq('«Row #4: 9 _ _ 7 2 _ _ _ _»')
    end
  end
end
