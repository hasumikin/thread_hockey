require 'socket'
require 'json'
require 'pry'

class Main

  PORT = 12345

  def initialize
    @server = TCPServer.open(PORT)
    @game_counter = GameCounter.new
    loop do
      game
    end
  end

  def game
    player1 = @server.accept
    player2 = @server.accept
    Thread.new([player1, player2]) do |sock1, sock2|
      @game_counter.inc
      begin
        puts 'Game Start'
        field = Field.new
        fields = field.to_json
        sock1.puts(fields)
        sock2.puts(fields)
        loop do
          p1 = sock1.gets
          p2 = sock2.gets
          if connecting?(p1, p2)
            field.update(JSON.parse(p1), JSON.parse(p2))
            sock1.puts field.to_json
            sock2.puts field.reverse.to_json
          else
            break
          end
        end
      ensure
        sock1.close
        sock2.close
        @game_counter.dec
      end
    end
  end

  private

  def connecting?(p1, p2)
    p1 && p2
  end


end