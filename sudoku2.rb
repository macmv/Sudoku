#! /usr/local/bin/ruby

class Point

  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

end

class Board

  attr_accessor :board

  def initialize
    @board = []
    9.times do
      new_row = []
      9.times do
        new_row.push nil
      end
      @board.push new_row
    end
    @board = solve_board @board
    nil
  end
  def print
    @board.each_with_index do |row, row_num|
      if row_num % 3 == 0
        puts "-" * 25
      end
      text = ""
      row.each_with_index do |item, item_num|
        if item_num % 3 == 0
          text += "| "
        end
        text += (item.nil? ? " " : item.to_s) + " "
      end
      puts text + "| "
    end
    puts "-" * 25
  end
  def pick_out_numbers
    shuffle_board_locs.each do |p|
      new_board = copy_board @board
      new_board[p.y][p.x] = nil
      if is_one_solution? new_board
        @board = new_board
      end
    end
    nil
  end
  def get_loc(box_x, box_y, x, y)
    @board[box_y * 3 + y][box_x * 3 + x]
  end
  
  private

  def is_one_solution?(board)
    new_board = copy_board board
    until board_is_full? board
      put_piece_down = false
      board.each_with_index do |row, row_num|
        row.each_with_index do |item, item_num|
          next if !item.nil?
          # at nil loc
          legal_boards = 0
          valid_num = nil
          (1..9).each do |num|
            new_board[row_num][item_num] = num
            if is_legal_board? new_board
              legal_boards += 1
              valid_num = num
            end
          end
          if legal_boards == 1
            new_board[row_num][item_num] = valid_num
            put_piece_down = true
          else
            new_board[row_num][item_num] = nil
          end
        end
      end
      if !put_piece_down
        return false
      end
      board = new_board
    end
    true
  end
  def solve_board(board)
    new_board = copy_board board
    board.each_with_index do |row, row_num|
      row.each_with_index do |item, item_num|
        next if !item.nil?
        # at nil loc
        rand_arr.each do |num|
          new_board[row_num][item_num] = num
          if is_legal_board? new_board
            solved = solve_board new_board
            return solved if !solved.nil?
          end
        end
        return nil
      end
    end
    new_board
  end
  def is_legal_board?(board)
    # check rows / columns
    2.times do
      board.each do |row|
        row.each_with_index do |item_a, item_a_num|
          row.each_with_index do |item_b, item_b_num|
            if item_a_num != item_b_num && item_a == item_b && item_a != nil
              return false
            end
          end
        end
      end
      board = rotate_board board
    end
    # check boxes
    3.times do |row_num|
      3.times do |item_num|
        box = [board[row_num * 3 + 0][item_num * 3 + 0],
               board[row_num * 3 + 1][item_num * 3 + 0],
               board[row_num * 3 + 2][item_num * 3 + 0],
               board[row_num * 3 + 0][item_num * 3 + 1],
               board[row_num * 3 + 1][item_num * 3 + 1],
               board[row_num * 3 + 2][item_num * 3 + 1],
               board[row_num * 3 + 0][item_num * 3 + 2],
               board[row_num * 3 + 1][item_num * 3 + 2],
               board[row_num * 3 + 2][item_num * 3 + 2]]
        box.each_with_index do |item_a, item_a_num|
          box.each_with_index do |item_b, item_b_num|
            if item_a_num != item_b_num && item_a == item_b && item_a != nil
              return false
            end
          end
        end
      end
    end
    true
  end
  def rotate_board(board)
    new_board = []
    9.times do
      new_row = []
      9.times do
        new_row.push nil
      end
      new_board.push new_row
    end
    board.each_with_index do |row, row_num|
      row.each_with_index do |item, item_num|
        new_board[item_num][row_num] = item
      end
    end
    new_board
  end
  def copy_board(board = @board)
    new_board = []
    board.each do |row|
      new_row = []
      row.each do |item|
        new_row.push item
      end
      new_board.push new_row
    end
    new_board
  end
  def rand_arr
    (1..9).to_a.shuffle
  end
  def board_is_full?(board)
    board.each do |row|
      row.each do |item|
        return false if item.nil?
      end
    end
    true
  end
  def shuffle_board_locs
    a = []
    @board.each_with_index do |row, row_num|
      row.each_with_index do |item, item_num|
        a.push Point.new item_num, row_num
      end
    end
    a.shuffle
  end
end

if __FILE__ == $0
  b = Board.new
  b.print
  b.pick_out_numbers
  b.print
end