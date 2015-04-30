require_relative 'board.rb'

class CheckersPiece

  attr_accessor :position
  attr_reader   :king, :color, :avatar

  FORWARD  = [[1,  1], [-1,  1]]
  BACKWARD = [[1, -1], [-1, -1]]

  def initialize(color, position, board)
    @position = position
    @king     = false
    @color    = color
    @board    = board
    @avatar   = ' ◉ '.colorize(color)
  end

  def move_to(new_position)
    @board[@position] = nil
    @position = new_position
    @board[@position] = self
    promote! if should_be_promoted
  end

  def possible_jumps
    jumps = Array.new
    move_directions.each do |direction|
      slide_move = slide_piece(direction)
      next if !@board.in_range?(slide_move)
      if @board.occupied_by?(slide_move) == other_color
        jump_move = jump_piece(direction)
        jumps << jump_move if @board.in_range?(jump_move)
      end
    end
    jumps
    #possible_jumps.include?(end_position) ? return true : return false
  end

  def possible_slides
    slides = slide_moves.select do |move|
      @board.in_range?(move) && @board.unoccupied?(move)
    end
    #unoccupied_slides.include?(end_position) ? return true : return false
  end

  def promote!
    @king   = true
    @avatar = ' ♛ '.colorize(color)
  end

  #private

    def end_rows
      end_row_index = (@color == :blue ? 7 : 0)
      (0...8).map { |col| [col, end_row_index]}
    end

    def jump_piece(modifier)
      modify_position(slide_piece(modifier), modifier)
    end

    def move_directions
      return FORWARD + BACKWARD if @king
      @color == :blue ? FORWARD : BACKWARD
    end

    def modify_position(position = @position, modifier)
      [position, modifier].transpose.map { |coord| coord.inject(:+) }
    end

    def other_color
      @color == :red ? :blue : :red
    end

    def should_be_promoted
      end_rows.include?(@position)
    end

    def slide_piece(modifier)
      modify_position(modifier)
    end

    def slide_moves
      move_directions.map { |direction| slide_piece(direction) }
    end

end

if __FILE__ == $PROGRAM_NAME
  a = CheckersPiece.new(:blue, [0,0], CheckersBoard.new)
  puts a.king
  b = CheckersPiece.new(:red,  [0,7], CheckersBoard.new )
  puts b.king
  a.move_to([5, 7])
  b.move_to([2, 0])
  print "#{a.end_rows} \n"
  print "#{b.end_rows} \n"
  puts a.king
  puts b.king
end
