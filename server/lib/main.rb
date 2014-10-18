require 'socket'
require 'json'
require 'pry'

class Main

  PORT = 12345

  def initialize
    @server = TCPServer.open(PORT)
    loop do
      game
    end
  end

  def game
    player1 = @server.accept
    player2 = @server.accept
    Thread.new([player1, player2]) do |sock1, sock2|
      puts 'Game Start'
      field = Field.new
      fields = field.to_json
      sock1.puts(fields)
      sock2.puts(fields)
      loop do
        p1 = sock1.gets
        p2 = sock2.gets
        puts field.event.to_s if field.event != [[]]
        if p1.include?('game_init') || p2.include?('game_init')
          field.restart
          next
        end
        field.update(JSON.parse(p1), JSON.parse(p2))
        sock1.puts field.to_json
        sock2.puts field.reverse.to_json
      end
    end
  end

end