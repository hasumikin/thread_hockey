require 'socket'

port = 12345

server = TCPServer.open(port)

player1 = server.accept
#player2 = server.accept

field = ThreadHockey.new
field = field.to_json
player1.write(field)


player1.close

