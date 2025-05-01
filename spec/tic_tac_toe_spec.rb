require_relative "../lib/tic_tac_toe.rb"

describe TicTacToe do
  let(:game) {described_class.new}

  describe "#initialize" do
    it "initializes with an empty board" do
      expect(game.board).to eq(["", "", "", "", "", "", "", "", ""])
    end
  end

  describe "#display_board" do
    it "displays the board" do
      game.board = ["X", "O", "X", "O", "X", "O", "X", "O", "X"]
      expect { game.display_board }.to output(" X | O | X \n----------\n O | X | O \n----------\n X | O | X \n").to_stdout
    end
  end

  describe "#input_to_index" do
    it "converts user input (1-9) to array index (0-8)" do
      expect(game.input_to_index("1")).to eq(0)
      expect(game.input_to_index("5")).to eq(4)
      expect(game.input_to_index("9")).to eq(8)
    end
  end

  describe "#move" do
    it "places a token on the board" do
      game.move(0, "X")
      expect(game.board[0]).to eq("x")
      game.move(4, "O")
      expect(game.board[4]).to eq("o")
    end
  end

  describe "#position_taken?" do
    it "returns false for empty positions" do
      expect(game.position_taken?(0)).to be false
    end
    it "returns true for occupied positions" do
      game.move(0, "X")
      expect(game.position_taken?(0)).to be true
    end
  end

  describe "#valid_move?" do
    it "returns true for valid moves" do
      expect(game.valid_move?(0)).to be true
    end

    it "returns false for out-of-bounds moves" do
      expect(game.valid_move?(9)).to be false
      expect(game.valid_move?(-1)).to be false
    end

    it "returns false for occupied positions" do
      game.move(0, "X")
      expect(game.valid_move?(0)).to be false
    end
  end

  describe "#turn_count" do
    it "returns 0 for new game" do
      expect(game.turn_count).to eq(0)
    end

    it "returns the correct count after moves" do
      game.move(0, "X")
      game.move(1, "O")
      expect(game.turn_count).to eq(2)
    end
  end

  describe "#current_player" do
    it "returns X for first move" do
      expect(game.current_player).to eq("x")
    end

    it "returns O for second move" do
      game.move(0, "X")
      expect(game.current_player).to eq("o")
    end
  end

  describe "#turn" do
    context "when valid input is given" do
      before do
        allow(game).to receive(:gets).and_return("1")
      end
      it "makes a move" do
        expect { game.turn }.to change { game.board[0] }.from("").to("x")
      end


      it "displays the board" do
        expect { game.turn }.to output(/x |  |  /).to_stdout
      end

    end

    context "when invalid input is given" do
      before do
         # First input is invalid (10), second is valid (1)
        allow(game).to receive(:gets).and_return("10", "1")
      end

      it "prompts for input again" do
        expect { game.turn }.to output(/Invalid input/).to_stdout
      end

      it "makes a valid move after invalid input" do
        expect { game.turn }.to change { game.board[0] }.from("").to("x")
      end
    end

    context "when position is already taken" do

      before do
        game.board[0] = "x"
        # First input is taken position (1), second is valid (2)
        allow(game).to receive(:gets).and_return("1", "2")
      end

      it "prompts again for taken position" do
        expect { game.turn }.to output(/Invalid move position already taken please select empty place/).to_stdout
      end

      it "makes a valid move after taken position" do
        expect { game.turn }.to change { game.board[1] }.from("").to("o")
      end
      
      it "displays the board after valid move" do
        expect { game.turn }.to output(/x | o |  /).to_stdout
      end
    end
  end

  describe "#won?" do

    it "returns false for empty board" do
      expect(game.won?).to be false
    end

    it "detects horizontal wins" do
      # Top row
      game.board = ["X", "X", "X", "", "", "", "", "", ""]
      expect(game.won?).to eq([0, 1, 2])

      # Middle row
      game.board = ["", "", "", "O", "O", "O", "", "", ""]
      expect(game.won?).to eq([3, 4, 5])

      # Bottom row
      game.board = ["", "", "", "", "", "", "X", "X", "X"]
      expect(game.won?).to eq([6, 7, 8])
    end

    it "detects vertical wins" do
      # Left column
      game.board = ["X", "", "", "X", "", "", "X", "", ""]
      expect(game.won?).to eq([0, 3, 6])

      # Middle column
      game.board = ["", "O", "", "", "O", "", "", "O", ""]
      expect(game.won?).to eq([1, 4, 7])

      # Right column
      game.board = ["", "", "X", "", "", "X", "", "", "X"]
      expect(game.won?).to eq([2, 5, 8])
    end

    it "detects diagonal wins" do
      # Left to right diagonal
      game.board = ["X", "", "", "", "X", "", "", "", "X"]
      expect(game.won?).to eq([0, 4, 8])

      # Right to left diagonal
      game.board = ["", "", "O", "", "O", "", "O", "", ""]
      expect(game.won?).to eq([2, 4, 6])
    end

    it "returns false for no win" do
      game.board = ["X", "O", "X", "O", "X", "", "", "", ""]
      expect(game.won?).to be false
    end

    it "returns false for a full board with no winner" do
      game.board = ["X", "O", "X", "O", "X", "O", "O", "X", "O"]
      expect(game.won?).to be false
    end
  end

  describe "#full?" do
    it "returns false for an empty board" do
      expect(game.full?).to be false
    end

    it "returns true for a full board" do
      game.board = ["X", "O", "X", "O", "X", "O", "O", "X", "O"]
      expect(game.full?).to be true
    end

    it "returns false for a partially filled board" do
      game.board = ["X", "", "X", "O", "", "O", "", "", ""]
      expect(game.full?).to be false
    end
  end

  describe "#draw?" do
    it "returns true for a full board with no winner" do
      game.board = ["X", "O", "X", "O", "X", "O", "O", "X", "O"]
      expect(game.draw?).to be true
    end

    it "returns false for a full board with a winner" do
      game.board = ["X", "O", "X", "O", "X", "O", "X", "", ""]
      expect(game.draw?).to be false
    end

    it "returns false for an empty board" do
      expect(game.draw?).to be false
    end
  end

  describe "#over?" do
    it "returns true if the game is won" do
      game.board = ["X", "X", "X", "", "", "", "", "", ""]
      expect(game.over?).to be true
    end

    it "returns true if the game is a draw" do
      game.board = ["X", "O", "X", "O", "X", "O", "O", "X", "O"]
      expect(game.over?).to be true
    end

    it "returns false for an ongoing game" do
      game.board = ["X", "", "", "", "", "", "", "", ""]
      expect(game.over?).to be false
    end
  end

  describe "#winner" do

    it "returns nil for no winner" do
      expect(game.winner).to be_nil
    end

    it "returns X for X win" do 
      game.board = ["X", "X", "X", "", "", "", "", "", ""]
      expect(game.winner).to eq("x")
    end

    it "returns O for O win" do
      game.board = ["O", "O", "O", "", "", "", "", "", ""]
      expect(game.winner).to eq("o")
    end
  end

  describe "#play" do
    context "when X wins" do

      before do
        # Simulate a game where X wins in 3 moves (top row)
        allow(game).to receive(:gets).and_return("1", "4", "2", "5", "3")
      end

      it "plays until X wins" do
        expect { game.play }.to output(/Congratulations Player x! Won the game/).to_stdout
      end
    end

    context "when O wins" do
      before do
        # Simulate a game where O wins in 4 moves (middle column)
        allow(game).to receive(:gets).and_return("1", "2", "3", "5", "7", "8")
      end

      it "plays until O wins" do
        expect { game.play }.to output(/Congratulations Player o! Won the game/).to_stdout
      end
    end

    context "when the game is a draw" do
      
      before do
        # Simulate a draw scenario
        allow(game).to receive(:gets).and_return("1", "2", "3", "5", "4", "6", "8", "7", "9")
      end

      it "plays until board is full" do
        expect { game.play }.to output(/The game is draw no one can win/).to_stdout
      end
    end
  end

end
