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

SOLVED = <<-STR
569438172
328197654
147562983
931725846
872614539
456983721
684259317
795341268
213876495
STR

RSpec.describe Puzzle do
  let(:puzzle) { Puzzle.new(parse_puzzle_data(PUZZLE)) }

  describe "#pretty_print" do
    it "prints puzzle" do
      expect(puzzle.pretty_print).to eq PUZZLE.chomp
    end
  end

  describe "#solved?" do
    let(:solved_puzzle) { Puzzle.new(parse_puzzle_data(SOLVED)) }

    it "returns true if all tiles are filled" do
      expect(puzzle.solved?).to be_falsey
    end

    it "returns false if there are unfilled tiles" do
      expect(solved_puzzle.solved?).to be_truthy
    end
  end

  describe "#solve!" do
    it "fills in tiles untill puzzle is solved" do
      puzzle.solve!
      expect(puzzle).to be_solved
    end
  end
end
