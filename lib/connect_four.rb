class Player
  attr_accessor :color
  attr_reader :token

  def initialize(color)
    @color = color
    @token = "\e[1;31;44m ☻ \e[0m" if @color == "red"
    @token = "\e[1;93;44m ☻ \e[0m" if @color == "yellow"
  end

  def turn
    puts "#{@color.capitalize}, where would you like to go?"
    column = gets.chomp
  end
end

class Game
  def initialize
    @blank = "\e[2;36;44m ☻ \e[0m"
    @board = []
    6.times {@board << [@blank, @blank, @blank, @blank, @blank, @blank, @blank]}
    @red = Player.new("red")
    @yellow = Player.new("yellow")
    @current = @red
  end

  def play
    42.times do
      puts_board
      var = @current.turn
      while valid?(var) == false
        var = @current.turn
      end
      exit if game_won?
      switch
    end
    puts "Tie game!"
  end

  def puts_board
    puts "\e[1m 1  2  3  4  5  6  7\e[0m"
    @board.each { |arr| puts arr.join }
  end

  def valid?(i)
    i = i.to_i - 1
    if @board[0][i] != @blank || i == -1
      puts "Please enter a valid column."
      false
    else
      [5, 4, 3, 2, 1, 0].each do |j|
        if @board[j][i] == @blank
          @board[j][i] = @current.token
          break
        end
      end
    end
  end

  def game_won?
    if rows? || columns? || diagonals?
      puts_board
      puts "\n\e[5;97;40m#{@current.color.capitalize} wins!\e[0m"
      return true
    end
  end

  def rows?
    @board.any? do |row|
      [row[0], row[1], row[2], row[3]].all? {|x| x == @current.token} ||
      [row[1], row[2], row[3], row[4]].all? {|x| x == @current.token} ||
      [row[2], row[3], row[4], row[5]].all? {|x| x == @current.token} ||
      [row[3], row[4], row[5], row[6]].all? {|x| x == @current.token}
    end
  end

  def columns?
    [0, 1, 2, 3, 4, 5, 6].any? do |i|
      [@board[0][i], @board[1][i], @board[2][i],
      @board[3][i]].all? {|x| x == @current.token} ||
      [@board[1][i], @board[2][i], @board[3][i],
      @board[4][i]].all? {|x| x == @current.token} ||
      [@board[2][i], @board[3][i], @board[4][i],
      @board[5][i]].all? {|x| x == @current.token}
    end
  end

  def diagonals?
    [[2, 0], [1, 0], [2, 1], [0, 0], [1, 1], [2, 2], [0, 1],
    [1, 2], [2, 3], [0, 2], [1, 3], [0, 3]].any? do |i, j|
      [@board[i][j], @board[i+1][j+1], @board[i+2][j+2],
       @board[i+3][j+3]].all? {|x| x == @current.token}
    end ||
    [[3, 0], [4, 0], [3, 1], [5, 0], [4, 1], [3, 2], [5, 1],
    [4, 2], [3, 3], [5, 2], [4, 3], [5, 3]].any? do |i, j|
      [@board[i][j], @board[i-1][j+1], @board[i-2][j+2],
       @board[i-3][j+3]].all? {|x| x == @current.token}
    end
  end

  def switch
    if @current == @red
      @current = @yellow
    else
      @current = @red
    end
  end
end

Game.new.play
