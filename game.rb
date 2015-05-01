require_relative 'board.rb'
require_relative 'errors.rb'
require 'io/console'


class CheckersGame
  attr_reader :board, :turn

  def initialize()
    @board        = CheckersBoard.new
    @turn         = :blue
    @chosen_piece = nil
    @jumping      = false
  end

  def play
    until game_is_won
      begin
        @board.display_for(:blue)
        print "It is currently #{turn}'s turn! \n"
        do_input(STDIN.getch)
      rescue IllegalMoveError => e
        puts e
        retry
      end
    end
    print

  end

  def game_is_won
    @board.get_all_pieces(:red).empty? || @board.get_all_pieces(:blue).empty?
  end

  def do_input(key)
    case key
    when "w"
      @board.set_highlight(:up)
    when "a"
      @board.set_highlight(:left)
    when "s"
      @board.set_highlight(:down)
    when "d"
      @board.set_highlight(:right)
    when "\r"
      select_piece
    when "q"
      exit_game
    end
  end

  def exit_game
    #save current game
    exit
  end

  def make_move
    if @jumping
      make_jump_move
    else
      if @chosen_piece.possible_jumps.include?(@board.highlight)
        make_jump_move
      elsif @chosen_piece.possible_slides.include?(@board.highlight)
        make_slide_move
      else
        raise IllegalMoveError.new("You can't put that piece there!")
      end
    end
  end

  def select_piece
    if @chosen_piece.nil?
      print "you have chosen a piece!\n"
      choose_piece
    else
      make_move
    end
  end

  #private
    def choose_piece
      if @board.occupied_by?(@board.highlight) == @turn
        select_valid_piece(@board.highlight)
      else
        raise IllegalMoveError.new("That's not a piece you can choose!")
      end
    end

    def end_turn
      @turn = (@turn == :red ? :blue : :red)
      @jumping = false
      @chosen_piece = nil
    end

    def make_jump_move
      @chosen_piece.move_to(@board.highlight)
      @jumping = true
      print "move made to #{@board.highlight}!!"
      if @chosen_piece.possible_jumps.empty?
        end_turn
      else
        print "#{@turn} is currently jumping! Select your next space!"
      end
    end

    def make_slide_move
      @chosen_piece.move_to(@board.highlight)
      end_turn
    end

    def select_valid_piece(position)
      if !@board[position].all_valid_moves.empty?
        @chosen_piece = @board[position]
      else
        raise IllegalMoveError.new("That piece has no available moves!")
      end
    end

end


if __FILE__ == $PROGRAM_NAME
  game = CheckersGame.new
  game.play
end
