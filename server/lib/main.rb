require 'socket'

class Main

  PORT = 12345

  def initialize
    @server = TCPServer.open(PORT)
    wait2palyers
  end

  def wait2palyers
    player1 = @server.accept
    player2 = @server.accept

    field = Field.new
    field = field.to_json
    player1.write(field)
    player2.write(field)

    player1.close
    player2.close
  end

end