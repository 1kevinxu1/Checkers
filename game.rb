require_relative 'board.rb'
require 'io/console'


class CheckersGame
  attr_reader :board

  KEY_COMMANDS = {

  def initialize()
    @board        = CheckersBoard.new
    @turn         = :blue
    @chosen_piece = nil
  end

  def play
    until game_is_won
      do_input(STDIN.getch)
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

  def move_piece_to(end_position)
    if @chosen_piece.possible_jumps.include?(end_position)
      @chosen_piece.jump_to(end_position)
    elsif @chosen_piece.possible_slides.include?(end_position)
      @chosen_piece.slide_to(end_position)
      @chosen_piece = nil
      end_turn
    else
      raise "IllegalMoveError"
    end

  end

  def select_piece
    if @chosen_piece.nil?
      @chosen_piece = @board[@highlight]
    else
      move_piece_to(@highlight)
    end
  end

  #private
    def end_turn
      @turn = (@turn == :red ? :blue : :red)
    end

end


if __FILE__ == $PROGRAM_NAME
  game = CheckersGame.new
  game.board.display
  game.play
end
