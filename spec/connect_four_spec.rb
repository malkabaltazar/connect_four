require "connect_four"

describe Game do
  let(:game) {Game.new}

  describe ".switch" do
    context "when @current references @red" do
      it "returns @yellow" do
        expect(game.switch.token).to eql("\e[1;93;44m ☻ \e[0m")
      end
    end
  end

  describe ".valid?" do
    context "when given an invalid column" do
      it "returns false" do
        expect(game.valid?(8)).to eql(false)
      end
    end

    context "when given a valid column" do
      it "replaces first blank value from the bottom of said column" do
        expect(game.valid?(7)).to eql(nil)
        expect(game.instance_variable_get("@board")[5][6]).to eql("\e[1;31;44m ☻ \e[0m")
      end
    end
  end

  describe ".row?" do
    context "when no four tokens in a row are equal" do
      it "returns false" do
        expect(game.rows?).to eql(false)
      end
    end

    context "when four tokens in a row are equal" do
      it "returns true" do
        game.valid?(1); game.valid?(2); game.valid?(3); game.valid?(4)
        expect(game.rows?).to eql(true)
      end
    end
  end

  describe ".columns?" do
    context "when no four tokens in a column are equal" do
      it "returns false" do
        expect(game.columns?).to eql(false)
      end
    end

    context "when four tokens in a column are equal" do
      it "returns true" do
        game.valid?(1); game.valid?(1); game.valid?(1); game.valid?(1)
        expect(game.columns?).to eql(true)
      end
    end
  end

  describe ".diagonals?" do
    context "when no four diagonal tokens are equal" do
      it "returns false" do
        expect(game.diagonals?).to eql(false)
      end
    end

    context "when four tokens in an upward diagonal line are equal" do
      it "returns true" do
        game.valid?(1); game.valid?(1); game.valid?(1); game.valid?(2)
        game.valid?(2); game.valid?(3); game.switch; game.valid?(1)
        game.valid?(2); game.valid?(3); game.valid?(4)
        expect(game.diagonals?).to eql(true)
      end
    end

    context "when four tokens in an downward diagonal line are equal" do
      it "returns true" do
        game.valid?(7); game.valid?(7); game.valid?(7); game.valid?(6)
        game.valid?(6); game.valid?(5); game.switch; game.valid?(7)
        game.valid?(6); game.valid?(5); game.valid?(4)
        expect(game.diagonals?).to eql(true)
      end
    end
  end
end
