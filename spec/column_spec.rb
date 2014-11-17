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

RSpec.describe Column do
  let(:puzzle) { Puzzle.new(parse_puzzle_data(PUZZLE)) }
  let(:column) { Column.new(5, 1, puzzle.tiles) }

  describe "#inspect" do
    it "returns nice inspect string" do
      expect(column.inspect).to eq('«Column #1: 5 _ 1 9 _ _ 6 _ _»')
    end
  end
end
