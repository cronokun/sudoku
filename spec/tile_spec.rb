require 'spec_helper'

RSpec.describe Tile do
  let(:tile) { Tile.new(8, 4, 5) }

  describe "#inspect" do
    it "returns pretty inspect string" do
      expect(tile.inspect).to eq("«Tile: '8', 4x5»")
    end
  end
end
