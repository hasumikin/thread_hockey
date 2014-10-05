require 'curses'
require 'pry'
require 'timeout'

Curses.init_screen
Curses.cbreak
Curses.noecho
loop do

  input = nil
  begin
    timeout(1) do
      input = Curses.getch
      case input
      when 'n'
        puts '左'
      when 'm'
        puts '右'
      else
        puts 'そのた'
      end
      Curses.getstr
      sleep
    end
  rescue => e
  end

  # sleep 0.9
  # input = IO.select([STDIN], [], [], 0.1)
  # if input
  #   ch = Curses.getch
  #   case ch
  #   when 'n'
  #     puts '左'
  #   when 'm'
  #     puts '右'
  #   else
  #     puts 'そのた'
  #   end
  # else
  #   puts 'nil'
  # end
end
