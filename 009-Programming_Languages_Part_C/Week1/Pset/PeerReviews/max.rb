# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = [
    rotations([[0, 0], [1, 0], [0, 1], [1, 1], [2,1]]),
    [[[0, 0], [-1, 0], [1, 0], [-2, 0], [2, 0]],
     [[0, 0], [0, -1], [0, 1], [0, -2], [0, 2]]],
    rotations([[0, 0], [0, -1], [1, 0]])
  ] + All_Pieces

  # your enhancements here
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end
end

class MyBoard < Board
  # your enhancements here
  def initialize(game)
    super(game)
    @current_block = MyPiece.next_piece(self)
    @next_piece_override = false
  end

  def next_piece
    if @next_piece_override
      @current_block = MyPiece.new([[[0, 0]]], self)
      @current_pos = nil
      @next_piece_override = false
    else
      super()
    end
  end

  def cheat
    if @score >= 100 && !@next_piece_override
      @score -= 100
      @next_piece_override = true
    end
  end
end

class MyTetris < Tetris
  # your enhancements here
  def key_bindings
    super()
    @root.bind('u', proc {
      @board.rotate_clockwise
      @board.rotate_clockwise
    })
    @root.bind('c', proc {@board.cheat})
  end

  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
end

