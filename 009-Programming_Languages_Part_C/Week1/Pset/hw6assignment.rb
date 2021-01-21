# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  Cheat_Piece = [[[0, 0]]]
  New_Pieces = [rotations([[0, 0], [1, 0], [0, 1], [1, 1], [2, 1]]),  # block + dot
                [[[0, 0], [-1, 0], [-2, 0], [1, 0], [2, 0]], # longer one (only needs two)
                [[0, 0], [0, -1], [0, -2], [0, 1], [0, 2]]],
                rotations([[0, 0], [0, -1], [1, 0]])]   # 3 piece "angle"
  All_My_Pieces = All_Pieces + New_Pieces

  def self.next_piece (board, cheat=false)
    if cheat
      MyPiece.new(Cheat_Piece, board)
    else
      MyPiece.new(All_My_Pieces.sample, board)
    end
  end

  def size
    current_rotation.size
  end
end

class MyBoard < Board
  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
    @cheat = false
  end

  def next_piece
    @current_block = MyPiece.next_piece(self, @cheat)
    @cheat = false
    @current_pos = nil
  end

  def cheat
    if @score >= 100 and !@cheat
      @cheat = true
      @score -= 100
    end
  end  

  def rotate_180
    rotate_clockwise
    rotate_clockwise
  end

  # override to accomodate different sizes of blocks (1, 3, and 5)
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(@current_block.size - 1)).each{|index| # iterate 0 throug block size insted of hardcoded 0..3
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

end

class MyTetris < Tetris
  def initialize
    super
    @root.bind('u', proc {@board.rotate_180})
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


