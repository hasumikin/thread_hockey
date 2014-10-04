require 'json'

class Field
  attr_accessor :ball, :opponent_keeper, :my_keeper
  ENDLINE = "------------                 ------------"
  KEEPER  = '======='
  BALL  = 'o'
  HEIGHT = 30

  def initialize
    @ball = {x: 10, y: 10}
    @opponent_keeper = { pos: 17 }
    @my_keeper = { pos: 17 }
    @ball_vector = first_vector
  end

  def update(mine, opponent)
    act_ball
    act_keeper(mine[:key])

  end

  def to_json
    {
      ball: @ball,
      my_keeper: @my_keeper,
      opponent_keeper: @opponent_keeper
    }.to_json
  end

  private

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

  def act_ball
    moved = @ball.dup
    moved[:x] += @ball_vector[0]
    moved[:y] += @ball_vector[1]
    return unless inner?(moved[:x], moved[:y])
    @ball = moved
  end

  def act_keeper(act)
    case act
    when 'r'
      @my_keeper[:pos] += 1
    when 'l'
      @my_keeper[:pos] += -1
    end

  end
end