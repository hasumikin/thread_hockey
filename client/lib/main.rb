require 'json'
require 'curses'
require 'pry'

class Main

  def initialize(host='localhost')
    Curses.init_screen
    Curses.cbreak
    Curses.noecho
    Curses.timeout = 0
    @field = Field.new
    @sock = TCPSocket.open(host, 12345)
    flush
    game
  end

  private

  def game
    loop do
      input = Curses.getstr
      request = case input[0]
      when 'n'
        "{\"key\":\"l\"}"
      when 'm'
        "{\"key\":\"r\"}"
      else
        '{}'
      end
      @sock.puts request
      flush
      sleep 0.5
    end
  end

  def flush
    @field.set_pos JSON.parse(@sock.gets).deep_symbolize_keys
    @field.flush
  end

end
