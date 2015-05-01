require_relative 'piece.rb'
require 'colorize.rb'

class CheckersBoard

  attr_reader :grid, :highlight

  BACKGROUNDS = {0 => :white, 1 => :black, :highlight => :yellow}
  DIRECTION   = {
    :left  => [-1, 0],
    :up    => [0,  1],
    :down  => [0, -1],
    :right => [1,  0]
  }

  def initialize
    reset
    @highlight = [0,0]
  end

  def [](position)
    x, y = position
    @grid[x][y]
  end

  def []=(position, object)
    x, y = position
    @grid[x][y] = object
  end

  def display_for(color)
    5.times {print_newline}
    (0...8).each do |row|
      (0...8).each do |x|
        y = (color == :blue ? 7 - row : row)
        render_square([x, y])
      end
      print_newline
    end
    5.times {print_newline}
  end

  def get_all_pieces(color)
    @grid.flatten.compact.select { |piece| piece.color == color }
  end

  def in_range?(position)
    return position.all? { |coord| coord.between?(0,7) }
  end

  def occupied_by?(position)
    square = self[position]
    return square.color if square
    return nil
  end

  def reset
    @grid = Array.new(8) {Array.new(8) {nil}}
    seed_board
  end

  def set_highlight(modifier)
    new_position = [@highlight, DIRECTION[modifier]].transpose.map do |coord|
      coord.inject(:+)
    end
    @highlight = new_position
  end

  def unoccupied?(position)
    return self[position] == nil
  end

  #private
    def render_square(position)
      x, y = position
      square_object = self[position]
      square_display = square_object ? square_object.avatar : '   '
      print "#{set_background(square_display, position)}"
    end

    def seed_board
      3.times do |y|
        (0...8).each do |x|
          seed_piece([x, 7-y], :red)
          seed_piece([x,   y], :blue)
        end
      end
    end

    def seed_piece(position, color)
      x, y = position
      if (x + y) % 2 == 0
        #print position
        self[position] = CheckersPiece.new(color, position, self)
      end
    end

    def set_background(string, position)
      string.colorize(:background => background_color(position))
    end

    def background_color(position)
      x, y = position
      if position == @highlight
        BACKGROUNDS[:highlight]
      else
        BACKGROUNDS[(x + y) % 2]
      end
    end

    def print_newline
      print "\n"
    end
end
