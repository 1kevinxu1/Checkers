require_relative 'board.rb'
require_relative 'errors.rb'
require 'io/console'


class CheckersGame
  attr_reader :board

  KEY_COMMANDS = {

  def initialize()
    @board        = CheckersBoard.new
    @turn         = :blue
    @chosen_piece = nil
    @jumping      = false
  end

  def play
    until game_is_won
      do_input(STDIN.getch)
      @board.display_for(@turn)
    end
  end

  def game_is_won
    @board.get_all_pieces(:red).empty? || @board.get_all_pieces(:blue).empty?
  end

  def do_input(key)
    case key
    when "w", "\e[A"
      @board.set_highlight(:up)
    when "a", "\e[D"
      @board.set_highlight(:left)
    when "s", "\e[B"
      @board.set_highlight(:down)
    when "d", "\e[C"
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
      make_jump_move  if @chosen_piece.possible_jumps.include?(@highlight)
      make_slide_move if @chosen_piece.possible_slides.include?(@highlight)
      raise IllegalMoveError.new("You can't put that piece there!")
    end
  end

  def select_piece
    if @chosen_piece.nil?
      choose_piece
    else
      make_move
    end
  end

  #private
    def choose_piece
      if @board.occupied_by?(@board.highlight)
        @chosen_piece = @board[@board.highlight]
      else
        raise IllegalMoveError.new("There's no piece to choose!")
      end
    end

    def make_jump_move
      if @jumping && @chosen_piece.possible_jumps.empty?
        @chosen_piece = nil
        @jumping = false
        end_turn
      else
        @chosen_piece.move_to(@board.highlight)
        @jumping = true
      end
    end

    def make_slide_move
      @chosen_piece.move_to(@board.highlight)
      @chosen_piece = nil
      end_turn
    end

    def end_turn
      @turn = (@turn == :red ? :blue : :red)
    end

end


if __FILE__ == $PROGRAM_NAME
  game = CheckersGame.new
  game.board.display
  game.play
end
