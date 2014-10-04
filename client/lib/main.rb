require 'json'
require 'io/console'
require 'curses'

class Main

  def initialize(host='localhost')
    Curses.init_screen 
    Curses.crmode
    @field = Field.new    
    @sock = TCPSocket.open(host, 12345)
    flush
    game
  end

  private

  def game
    loop do
      sleep 1
      input = IO.select([STDIN], [], [], 0)
      if input
        ch = Curses.getch
        request = case ch
        when 'n'
          "{'key':'l'}"
        when 'm'
          "{'key':'r'}"
        else
          "{}"
        end
      else
        next
      end
      @sock.puts request
      flush
    end
  end

  def flush
    @field.set_pos JSON.parse(@sock.gets).deep_symbolize_keys
    @field.flush
  end

end
