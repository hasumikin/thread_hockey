require 'io/console'
require 'curses'
require 'pry'

Curses.crmode
loop do
  sleep 1
  input = IO.select([STDIN], [], [], 0)
  if input
    ch = Curses.getch
    case ch
    when 'n'
      puts '左'
    when 'm'
      puts '右'
    else
      puts 'そのた'
    end
  else
    puts 'nil'
  end
end
