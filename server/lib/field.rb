require 'json'
require_relative '../../common_config/base_field'

class Field < BaseField
  attr_accessor :ball, :p2_keeper, :p1_keeper

  def initialize
    @ball = {x: 10, y: 10}
    @p2_keeper = { pos: 17 }
    @p1_keeper = { pos: 17 }
    @ball_vector = first_vector
  end

  def update(p1, p2)
    act_ball
    act_keeper_p1(p1['key'])
    act_keeper_p2(p2['key'])
  end

  def to_json
    {
      ball: @ball,
      p1_keeper: @p1_keeper,
      p2_keeper: @p2_keeper
    }.to_json
  end

  private

  def inner?(x, y)
    x.between?(1, WIDTH - 1) && y.between?(1, HEIGHT - 1)
  end

  def first_vector
    vectors = []
    vectors << [1, 1]   # RightUp
    vectors << [1, -1]  # RightDown
    vectors << [-1, 1]  # LeftUp
    vectors << [-1, -1] # LeftDown
    vectors[rand(4)]
  end

  def act_ball
    moved = @ball.dup
    moved[:x] += @ball_vector[0]
    moved[:y] += @ball_vector[1]
    # if inner?(moved[:x], moved[:y])
      if moved[:x] == 0 || moved[:x] == WIDTH - 1
        @ball_vector[0] = @ball_vector[0] * (-1)
        moved[:x] += @ball_vector[0] * 2
      end
      if moved[:y] == 0 || moved[:y] == HEIGHT
        @ball_vector[1] = @ball_vector[1] * (-1)
        moved[:y] += @ball_vector[1] * 2
      end
      @ball = moved
    # end
  end

  def act_keeper_p1(act)
    case act
    when 'r'
      @p1_keeper[:pos] += 1
    when 'l'
      @p1_keeper[:pos] += -1
    end
  end
  def act_keeper_p2(act)
    case act
    when 'r'
      @p2_keeper[:pos] += 1
    when 'l'
      @p2_keeper[:pos] += -1
    end
  end
end