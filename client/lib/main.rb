require 'json'
require 'curses'
require 'timeout'
require 'pry'

class Main

  def initialize(host='localhost')
    Curses.init_screen
    Curses.cbreak
    Curses.noecho
    @field = Field.new
    @sock = TCPSocket.open(host, 12345)
    flush
    game
  end

  private

  def game
    loop do
      request = "{}"
      begin
        timeout(0.5) do
          input = Curses.getch
          request = case input
          when 'n'
            "{\"key\":\"l\"}"
          when 'm'
            "{\"key\":\"r\"}"
          else
            '{}'
          end
          Curses.getstr
          sleep
        end
      rescue => e
        @sock.puts request
        flush
      end
    end
  end

  def flush
    @field.set_pos JSON.parse(@sock.gets).deep_symbolize_keys
    @field.flush
  end

end
