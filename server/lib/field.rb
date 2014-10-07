require 'json'
require 'pry'
require_relative '../../common_config/base_field'

class Field < BaseField
  attr_accessor :ball, :p2_keeper, :p1_keeper

  KEEPER_MAX_POS = WIDTH - KEEPER.size - 1

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
    act_ball
    act_p1_keeper(p1["key"])
    act_p2_keeper(p2["key"])
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
    move = {x: @ball_vector[0], y: @ball_vector[1]}
    moved_x = (@ball[:x] + @move[:ball][:x]) + @ball_vector[0]
    moved_y = (@ball[:y] + @move[:ball][:y]) + @ball_vector[1]
    if moved_x == 0 || moved_x == WIDTH - 1
      @ball_vector[0] = @ball_vector[0] * (-1)
      move[:x] += @ball_vector[0] * 2
    end
    if moved_y == 0 || moved_y == HEIGHT
      @ball_vector[1] = @ball_vector[1] * (-1)
      move[:y] += @ball_vector[1] * 2
    end
    @move[:ball][:x] += move[:x]
    @move[:ball][:y] += move[:y]
  end

  def act_p1_keeper(act)
    keeper_pos = @p1_keeper[:pos] + @move[:p1_keeper]
    case act
    when 'r'
      @move[:p1_keeper] += 1 if keeper_pos < KEEPER_MAX_POS
    when 'l'
      @move[:p1_keeper] += -1 if keeper_pos > 1
    end
  end

  def act_p2_keeper(act)
    keeper_pos = @p2_keeper[:pos] + @move[:p2_keeper]
    case act
    when 'r'
      @move[:p2_keeper] += -1 if keeper_pos > 1
    when 'l'
      @move[:p2_keeper] += 1 if keeper_pos < KEEPER_MAX_POS
    end
  end

end