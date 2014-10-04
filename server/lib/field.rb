require 'json'

class Field
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