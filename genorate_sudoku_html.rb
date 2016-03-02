#! /usr/local/bin/ruby

require "./sudoku2.rb"

class Element
  attr_reader :text
  def to_s
    @text
  end
end

class Td < Element
  def initialize(board, main_tr_num, main_td_num, tr_num, td_num)
    @text = "<td width=20 height=25><center>#{board.get_loc(main_tr_num, main_td_num, tr_num, td_num)}</center></td>"
  end
end

class Tr < Element
  def initialize(board, main_tr_num, main_td_num, tr_num)
    @text = <<-HTML
        <tr>
#{Td.new(board, main_tr_num, main_td_num, tr_num, 0)}
#{Td.new(board, main_tr_num, main_td_num, tr_num, 1)}
#{Td.new(board, main_tr_num, main_td_num, tr_num, 2)}
        </tr>
    HTML
  end
end

class MainTd < Element
  def initialize(board, main_tr_num, main_td_num)
    @text = <<-HTML
      <td>
        <table style="width:80px" border="1" cellspacing="0px" cellpadding="2">
#{Tr.new(board, main_tr_num, main_td_num, 0)}
#{Tr.new(board, main_tr_num, main_td_num, 1)}
#{Tr.new(board, main_tr_num, main_td_num, 2)}
        </table>
      </td>
    HTML
  end
end

class MainTr < Element
  def initialize(board, num)
    @text = <<-HTML
    <tr>
#{MainTd.new(board, num, 0)}
#{MainTd.new(board, num, 1)}
#{MainTd.new(board, num, 2)}
    </tr>
    HTML
  end
end

class MainTable < Element
  def initialize(board)
    @text = <<-HTML
  <table>
#{MainTr.new(board, 0)}
#{MainTr.new(board, 1)}
#{MainTr.new(board, 2)}
  </table>
    HTML
  end
end

class Html

  attr_reader :text

  def initialize(b1, b2, b3, board_data)
    @text = <<-HTML
<html>
<body>
<h1><center>Sudoku #{board_data}</center></h1>
#{MainTable.new(b1).text}
<h1></h1>
#{MainTable.new(b2).text}
<h1></h1>
#{MainTable.new(b3).text}
</body>
</html>
HTML
  end

end

print "What level?: "
level = gets.chomp.to_i
print "how many sheets?:"
sheets = gets.to_i
sheets.times do |sheet_num|
  board_num = 1
  file = "boards/#{level}/#{board_num}.html"
  while File.exist?(file)
    board_num += 1
    file = "boards/#{level}/#{board_num}.html"
  end
  b1 = Board.new
  b1.print
  b1.pick_out_numbers level
  b1.print
  puts "#{((sheet_num * 3 + 1).to_f / (sheets * 3).to_f) * 100.0}%"
  b2 = Board.new
  b2.print
  b2.pick_out_numbers level
  b2.print
  puts "#{((sheet_num * 3 + 2).to_f / (sheets * 3).to_f) * 100.0}%"
  b3 = Board.new
  b3.print
  b3.pick_out_numbers level
  b3.print
  puts "#{((sheet_num * 3 + 3).to_f / (sheets * 3).to_f) * 100.0}%"
  h = Html.new b1, b2, b3, "#{level}:#{board_num}"
  File.open(file, "w") { |f| f.write h.text }
  puts 
end