require "rspec"
require "byebug"
require "./game_of_life"

RSpec.describe Board do
  describe "#initialize" do
    context "invalid size type" do
      it "raises error" do
        expect do
          Board.create("invalid")
        end.to raise_error(ArgumentError, "support numeric value only")
      end
    end

    context "size = 0" do
      it "raises error" do
        expect do
          Board.create(0)
        end.to raise_error(ArgumentError, "board size must > 0")
      end
    end

    context "valid size" do
      it "builds a valid board" do
        board = Board.create(2)
        expect(board.to_s).to eq("--\n--")
      end
    end
  end

  describe "#put_cell_to_position" do
    context "position < 1" do
      it "raises error" do
        board = Board.create(2)

        expect do
          board.put_cell_to_position(0, 1)
        end.to raise_error(ArgumentError, "position must > 0")
      end
    end

    context "position >= 1" do
      it "does not raise error" do
        board = Board.create(2)

        board.put_cell_to_position(1, 1)
        expect(board.to_s).to eq("x-\n--")
      end
    end
  end

  describe "#tick" do
    context "changable community" do
      it "changes correctly" do
        board = Board.create(3)
        board.put_cell_to_position(2, 1)
        board.put_cell_to_position(2, 2)
        board.put_cell_to_position(2, 3)

        board.tick

        expect(board.to_s).to eq("-x-\n-x-\n-x-")
      end
    end

    context "stable community" do
      it "keeps the community stable" do
        board = Board.create(3)
        board.put_cell_to_position(1, 1)
        board.put_cell_to_position(1, 2)
        board.put_cell_to_position(2, 1)
        board.put_cell_to_position(2, 2)

        expect do
          board.tick
        end.not_to change { board.to_s }
      end
    end
  end
end
