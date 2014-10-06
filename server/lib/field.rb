require 'json'
require 'pry'
require_relative '../../common_config/base_field'

class Field < BaseField
  attr_accessor :ball, :p2_keeper, :p1_keeper

  def initialize
    @ball = {x: 20, y: 15}
    @p2_keeper = { pos: 17 }
    @p1_keeper = { pos: 17 }
    @ball_vector = first_vector
    @move = {
      ball: {x: 0, y: 0},
      p1_keeper: 0,
      p2_keeper: 0
    }
  end

  def update(p1, p2)
    set_pos(p1, p2)
    move
     # act_ball
     # act_keeper_p1(p1['key'])
     # act_keeper_p2(p2['key'])
  end

  def reverse
    puts "reverse"
    reverse_move
    now = {
      ball: @ball,
      p1_keeper: @p1_keeper,
      p2_keeper: @p2_keeper
    }
    puts now
    puts "reverse_end"
  end

  def to_json
    puts "JSON"
    {
      ball: @ball,
      p1_keeper: @p1_keeper,
      p2_keeper: @p2_keeper
    }.to_json
  end

  private

  def set_pos(p1, p2)
    ball = ball_pos
    @move[:ball][:x] += ball[0]
    @move[:ball][:y] += ball[1]
    @move[:p1_keeper] += keeper_pos(p1["key"])
    @move[:p2_keeper] += keeper_pos(p2["key"])
  end

  def move
    @ball[:x] += @move[:ball][:x]
    @ball[:y] += @move[:ball][:y]
    @p1_keeper[:pos] += @move[:p1_keeper]
    @p2_keeper[:pos] += @move[:p2_keeper]
  end

  def reverse_move
    @ball[:x] -= @move[:ball][:x]
    @ball[:y] -= @move[:ball][:y]
    @p1_keeper[:pos] -= @move[:p1_keeper]
    @p2_keeper[:pos] -= @move[:p2_keeper]
  end

  def inner?(x, y)
    x.between?(1, ENDLINE.length) && y.between?(0, HEIGHT)
  end

  def first_vector
    vectors = []
    vectors << [1, 1]   # RightUp
    vectors << [1, -1]  # RightDown
    vectors << [-1, 1]  # LeftUp
    vectors << [-1, -1] # LeftDown
    vectors[rand(4)]
  end

  def ball_pos
    move = [0, 0]
    moved_x = @ball[:x] + @move[:ball][:x]
    moved_y = @ball[:y] + @move[:ball][:y]
    return move unless inner?(moved_x, moved_y)
    [@ball_vector[0], @ball_vector[1]]
  end

  def keeper_pos(act)
    case act
    when 'r'
      1
    when 'l'
      -1
    else
      0
    end
  end
=begin
  def act_ball
    moved = @ball.dup
    moved[:x] += @ball_vector[0]
    moved[:y] += @ball_vector[1]
    return unless inner?(moved[:x], moved[:y])
    @ball = moved
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
=end
end