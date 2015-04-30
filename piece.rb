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

    def move_directions
      return FORWARD + BACKWARD if @king
      @color == :blue ? FORWARD : BACKWARD
    end

    def modify_position(position = @position, modifier)
      [position, modifier].transpose.map { |coord| coord.inject(:+) }
    end

    def slide_piece(modifier)
      modify_position(modifier)
    end

    def jump_piece(modifier)
      modify_position(slide_piece(modifier), modifier)
    end

    def slide_moves
      move_directions.map { |direction| slide_piece(direction) }
    end

    def other_color
      @color == :red ? :blue : :red
    end
end
