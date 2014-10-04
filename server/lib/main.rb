require 'socket'

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
      field = Field.new
      fields = field.to_json
      sock1.puts(fields)
      sock2.puts(fields)
      loop do
        p1 = JSON.parse(sock1.gets)
        p2 = JSON.parse(sock2.gets)
        field.update(p1, p2)
        sock1.puts field.to_json
        sock2.puts field.to_json
        #sock2.puts field.reverse.to_json
      end
    end
  end

end