require 'json'
require 'socket'

class ThreadHockey
  attr_accessor :ball, :opponent_keeper, :my_keeper

  def initialize
    @ball = {x: 10, y: 10}
    @opponent_keeper = { pos: 17 }
    @my_keeper = { pos: 17 }
  end

  def to_json
    {
      ball: @ball,
      my_keeper: @my_keeper,
      opponent_keeper: @opponent_keeper
    }.to_json
  end
end

def wait_another_player
  return GAME_START if GAME_START
  while !GAME_START
    sleep 0.1
    @player2 = server.accept
  end
  GAME_START = true
end


port = 12345

server = TCPServer.open(port)

@player1 = server.accept
#player2 = server.accept

GAME_START = false
wait_another_player
#GAME_START = true if (player1 && player2)

field = ThreadHockey.new
field = field.to_json


  #sock.each_line do |line|
  #player_field = ThreadHockey.new
  player1.write(field)
  #  sock2.write("test\n")
  #end
#end

player1.close

=begin
json = {}

sock = TCPSocket.open("localhost", 12345)

STDIN.each_line do |line|
  sock.write(line)
  print sock.gets

end
=end
