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
    reset_pos
    set_move(p1, p2)
    move_pos
  end

  def reverse
    reset_pos
    move_pos_reverse
    self
  end

  def to_json
    {
      ball: @ball,
      p1_keeper: @p1_keeper,
      p2_keeper: @p2_keeper
    }.to_json
  end

  private

  def reset_pos
    init_instance = self.class.new
    @ball[:x] = init_instance.ball[:x]
    @ball[:y] = init_instance.ball[:y]
    @p1_keeper = init_instance.p1_keeper
    @p2_keeper = init_instance.p2_keeper
  end

  def set_move(p1, p2)
    ball = ball_move
    @move[:ball][:x] += ball[0]
    @move[:ball][:y] += ball[1]
    @move[:p1_keeper] += keeper_move(p1["key"])
    @move[:p2_keeper] += keeper_move(p2["key"])
  end

  def move_pos
    @ball[:x] += @move[:ball][:x]
    @ball[:y] += @move[:ball][:y]
    @p1_keeper[:pos] += @move[:p1_keeper]
    @p2_keeper[:pos] += @move[:p2_keeper]
  end

  def move_pos_reverse
    @ball[:x] -= @move[:ball][:x]
    @ball[:y] -= @move[:ball][:y]
    @p1_keeper[:pos] -= @move[:p2_keeper]
    @p2_keeper[:pos] -= @move[:p1_keeper]
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

  def ball_move
    move = [0, 0]
    moved_x = @ball[:x] + @move[:ball][:x] + @ball_vector[0]
    moved_y = @ball[:y] + @move[:ball][:y] + @ball_vector[1]
    return move unless inner?(moved_x, moved_y)
    [@ball_vector[0], @ball_vector[1]]
  end

  def keeper_move(act)
    case act
    when 'r'
      1
    when 'l'
      -1
    else
      0
    end
  end

end