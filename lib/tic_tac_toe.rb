class TicTacToe
attr_accessor :board
Win_combinations = [[0,1,2], [3,4,5], [6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
def initialize
empty = []
9.times {empty << ""}
@board = empty
end

def display_board
  puts " #{board[0]} | #{board[1]} | #{board[2]} "
  puts "----------"
  puts " #{board[3]} | #{board[4]} | #{board[5]} "
  puts "----------"
  puts " #{board[6]} | #{board[7]} | #{board[8]} "
end

def input_to_index(user_input)
 user_input.to_i - 1
end

def move(index, token = 'x')
board[index] = token
end

def position_taken?(index)
if (board[index] == "" || board[index] == " " || board[index] == nil)
  return false
else
  return true
end
end

def valid_move?(index)
if index.between?(0,8) && !position_taken?(index)
  return true
end
end

def turn_count
counter = 0
board.each do |spaces|
  if spaces == "x" || spaces == "o"
    counter += 1
  end
end
counter
end

def current_player
self.turn_count.even? ? "x" : "o"
end

def turn 
puts "Player #{self.current_player} please enter 1-9"
input = gets.chomp 
self.turn unless (1..9).include?(input.to_i)
position = self.input_to_index(input)

if valid_move?(position)
  move(position, self.current_player)
  self.display_board
else
puts "Invalid move position already taken please select empty place"
end
end

def won?
Win_combinations.each do |win_combination|
win_index_1 = win_combination[0]
win_index_2 = win_combination[1]
win_index_3 = win_combination[2]
position_1 = board[win_index_1]
position_2 = board[win_index_2]
position_3 = board[win_index_3]

if position_1 == position_2 && position_2 == position_3 && self.position_taken?(win_index_1)
return win_combination
end
end
false
end

def full?
  unless board.include?("")
  end 
end

def draw?
  self.full? && !self.won?
end

def over?
  self.won? || self.draw?
end

def winner
  if self.won?
    (self.current_player == "x") ? "o" : "x"
  end
end

def play 
  until self.over?
    self.turn
  end
  if self.won?
    puts "Congratulations Player #{self.winner}! Won the game"
  elsif self.draw?
    puts "The game is draw no one can win"
  end
end

end


