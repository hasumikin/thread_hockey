class Main

  def initialize
    @field = Field.new    
    @sock = TCPSocket.open('10.0.1.4', 12345)
    game
  end

  def game
    @field.set_pos JSON.parse(@sock.gets).deep_symbolize_keys
    @field.flush
  end

end
