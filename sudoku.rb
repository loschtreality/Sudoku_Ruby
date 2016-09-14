require 'colorize'


class Tile
  attr_accessor :value, :changable

  def initialize(value)
    @value = value
    value == "0" ? @changable = true : @changable = false
  end
end

class Board
  attr_accessor :grid

  def initialize
    @grid = Board.from_file(“./sudoku_files/sudoku1.txt")
  end

  def self.from_file(path)
    parsed = File.readlines(path).map do |line|
       line.chomp.split('')
    end
    parsed.map do |row|
      row.map {|value| Tile.new(value)}
    end
  end

  def update_tile(pos,new_value)
    location = @grid[pos.first][pos.last]
    p location.changable
    p location.value
    location.value = new_value if location.changable
  end

  def render
    @grid.each do |row|
      str_row = ""
      row.each do |col|
        unless col.changable
          str_row << " #{col.value} ".colorize(:red)
        else
          str_row << " #{col.value} "
        end
      end
      puts str_row
    end
  end

  def solved?
    @grid.each do |row|
      return false unless row_solved?(row)
    end

    @grid.dup.transpose.each do |row|
      return false unless row_solved?(row)
    end
    true
  end

  def row_solved?(row)
    row_values = row.map { |el| el.value }
    row_values.sort == ("1".."9").to_a
  end
end

class Game
  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def play_turn
    change = get_pos
    @board.update_tile(change[:coordinate],change[:value])
  end

  def play
    until @board.solved?
      @board.render
      play_turn
    end
    p "You win!"
  end

  def solve
    @board.grid.each do |row|
      row.each do |col|
        if col.value == "0"
          
        end
      end
    end
  end

  def get_pos
    puts "Choose a coordinate"
    coordinate = gets.chomp.split(",").map(&:to_i)
    puts "Choose a value"
    value = gets.chomp
    return {:coordinate => coordinate, :value => value}
  end
end

Game.new.play
